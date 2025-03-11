# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v0.3.0

### Key Changes (v0.3.0)

Support for multiple subject filters.

#### Variables (v0.3.0)

- Update the variable `iam_roles.subject_filter` to `iam_roles.subject_filters`. Change the input from a `string` to `list(string)`.

## Upgrading to v0.1.0

### Key Changes (v0.1.0)

This module serves as a continuation of the deprecated [`terraform-aws-mcaf-gitlab-oidc`](https://github.com/schubergphilis/terraform-aws-mcaf-gitlab-oidc/releases/tag/v0.2.1) module.

### Migration Steps (v0.1.0)

When upgrading to this module, ensure the following changes are applied:

- Use the `gitlab` sub-module instead of the previous module.
- Update the variable `iam_roles.subject_filter_allowed` to `iam_roles.subject_filter`.
- Update the variable `iam_roles.subject_filter.path` to `iam_roles.subject_filter.project_path`.
- The only structural change expected is the `move` of the `aws_iam_openid_connect_provider.default` resource.

By following these steps, the transition should be seamless while maintaining functionality.
