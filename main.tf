locals {
  provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.default["instance"].arn : data.aws_iam_openid_connect_provider.default["instance"].arn
  provider_url = var.create_oidc_provider ? aws_iam_openid_connect_provider.default["instance"].url : data.aws_iam_openid_connect_provider.default["instance"].url
}

################################################################################
# OIDC Provider
################################################################################

# We avoid using https scheme because the Hashicorp TLS provider has started following redirects starting v4.
# See https://github.com/hashicorp/terraform-provider-tls/issues/249
data "tls_certificate" "default" {
  url = "${replace(var.oidc_provider.thumbprint_url, "https", "tls")}:443"
}

data "aws_iam_openid_connect_provider" "default" {
  for_each = !var.create_oidc_provider ? { instance = true } : {}

  url = var.oidc_provider.url
}

resource "aws_iam_openid_connect_provider" "default" {
  for_each = var.create_oidc_provider ? { instance = true } : {}

  url             = var.oidc_provider.url
  client_id_list  = var.oidc_provider.client_ids
  thumbprint_list = [data.tls_certificate.default.certificates[0].sha1_fingerprint]
  tags            = var.tags
}

################################################################################
# AWS IAM Role
################################################################################

data "aws_iam_policy_document" "assume_role_policy" {
  for_each = var.iam_roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [local.provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "${local.provider_url}:sub"
      values   = each.value.subject_filter
    }
  }
}

module "oidc_role" {
  source  = "schubergphilis/mcaf-role/aws"
  version = "~> 0.4.0"

  for_each = var.iam_roles

  name                 = each.value.name != null ? each.value.name : each.key
  assume_policy        = data.aws_iam_policy_document.assume_role_policy[each.key].json
  description          = each.value.description
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary_arn
  policy_arns          = each.value.policy_arns
  postfix              = false
  role_policy          = each.value.policy
  tags                 = var.tags
}
