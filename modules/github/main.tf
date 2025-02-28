module "default" {
  source = "../../"

  create_oidc_provider = var.create_oidc_provider
  oidc_provider        = var.oidc_provider
  tags                 = var.tags

  # https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
  iam_roles = {
    for role, config in var.iam_roles : role => merge(config, {
      subject_filter = compact([
        config.subject_filter.branch != null ?
        "repo:${config.subject_filter.repository}:ref:refs/heads/${config.subject_filter.branch}" : null,
        config.subject_filter.environment != null ?
        "repo:${config.subject_filter.repository}:env:${config.subject_filter.environment}" : null,
        config.subject_filter.tag != null ?
        "repo:${config.subject_filter.repository}:ref:refs/tags/${config.subject_filter.tag}" : null,
      ])
    })
  }
}
