module "default" {
  source = "../../"

  create_oidc_provider = var.create_oidc_provider
  oidc_provider        = var.oidc_provider
  tags                 = var.tags

  # https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
  iam_roles = {
    for role, config in var.iam_roles : role => merge(config, {
      subject_filters = compact([
        for filter in config.subject_filters :
        filter.branch != null ? "repo:${filter.repository}:ref:refs/heads/${filter.branch}" :
        filter.environment != null ? "repo:${filter.repository}:env:${filter.environment}" :
        filter.tag != null ? "repo:${filter.repository}:ref:refs/tags/${filter.tag}" :
        null
      ])
    })
  }
}
