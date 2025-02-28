module "default" {
  source = "../../"

  create_oidc_provider = var.create_oidc_provider
  oidc_provider        = var.oidc_provider
  tags                 = var.tags

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
