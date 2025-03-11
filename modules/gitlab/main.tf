module "default" {
  source = "../../"

  create_oidc_provider = var.create_oidc_provider
  tags                 = var.tags

  # https://docs.gitlab.com/ci/cloud_services/aws/
  # The GitLab URL is used as the unique identifier (client_id) for the OIDC provider.
  # This ensures that the IAM role trust relationship in AWS correctly identifies GitLab as the issuer.
  # We default both client_ids and thumbprint_url to the GitLab URL to ensure a consistent and secure integration.
  oidc_provider = merge(var.oidc_provider, {
    client_ids     = [var.oidc_provider.url],
    thumbprint_url = var.oidc_provider.url
  })

  # A concatenation of metadata describing the GitLab CI/CD workflow including the group, project, branch, and tag. The sub field is in the following format:
  # project_path:{group}/{project}:ref_type:{type}:ref:{branch_name}
  # https://docs.gitlab.com/ee/ci/cloud_services/index.html#configure-a-conditional-role-with-oidc-claims
  iam_roles = {
    for role, config in var.iam_roles : role => merge(config, {
      subject_filter = [
        "project_path:${config.subject_filter.project_path}:ref_type:${config.subject_filter.ref_type}:ref:${config.subject_filter.ref}"
      ]
    })
  }
}
