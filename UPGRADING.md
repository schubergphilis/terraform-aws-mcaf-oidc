# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v0.1.0

### Key Changes

This module serves as a continuation of the deprecated [`terraform-aws-mcaf-gitlab-oidc`](https://github.com/schubergphilis/terraform-aws-mcaf-gitlab-oidc/releases/tag/v0.2.1) module.

### Migration Steps

When upgrading to this module, ensure the following changes are applied:

- Use the `gitlab` sub-module instead of the previous module.
- Update the variable `subject_filter.path` to `subject_filter.project_path`.
- The only structural change expected is the `move` of the `aws_iam_openid_connect_provider.default` resource.

By following these steps, the transition should be seamless while maintaining functionality.
