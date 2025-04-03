locals {
  provider             = var.create_oidc_provider ? aws_iam_openid_connect_provider.default["create"] : data.aws_iam_openid_connect_provider.default["create"]
  thumbprint_url_parse = provider::corefunc::url_parse(var.oidc_provider.thumbprint_url)
}

################################################################################
# OIDC Provider
################################################################################

# We avoid using https scheme because the Hashicorp TLS provider has started following redirects starting v4.
# See https://github.com/hashicorp/terraform-provider-tls/issues/249
data "tls_certificate" "default" {
  url = "tls://${local.thumbprint_url_parse.host}:443${local.thumbprint_url_parse.path}"
}

data "aws_iam_openid_connect_provider" "default" {
  for_each = !var.create_oidc_provider ? { create = true } : {}

  url = var.oidc_provider.url
}

resource "aws_iam_openid_connect_provider" "default" {
  for_each = var.create_oidc_provider ? { create = true } : {}

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
      identifiers = [local.provider.arn]
    }

    # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_iam-condition-keys.html#available-keys-for-iam
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "${local.provider.url}:sub"
      values   = each.value.subject_filters
    }

    dynamic "condition" {
      for_each = length(each.value.audience_filters) == 0 ? [each.value.audience_filters] : []
      content {
        test     = "ForAnyValue:StringLike"
        variable = "${local.provider.url}:aud"
        values   = condition.value
      }
    }
  }
}

module "oidc_role" {
  source  = "schubergphilis/mcaf-role/aws"
  version = "~> 0.4.0"

  for_each = var.iam_roles

  name                 = coalesce(each.value.name, each.key)
  assume_policy        = data.aws_iam_policy_document.assume_role_policy[each.key].json
  description          = each.value.description
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary_arn
  policy_arns          = each.value.policy_arns
  postfix              = false
  role_policy          = each.value.policy
  tags                 = var.tags
}
