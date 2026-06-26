# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v0.8.0

### Key Changes (v0.8.0)

#### Bug fix: corrected GitHub environment OIDC subject claim mapping in `modules/github`

The `environment` subject filter previously generated an incorrect `sub` claim format:

```
repo:<org>/<repo>:env:<environment>
```

This has been corrected to match the actual GitHub OIDC token format:

```
repo:<org>/<repo>:environment:<environment>
```

If you are using `environment` in `subject_filters` for the `modules/github` submodule, Terraform will update the IAM role trust policy condition. No variable changes are required — the fix is automatic on the next apply.

#### Feature: immutable GitHub OIDC subject claim support in `modules/github`

GitHub repositories created after July 15, 2026, or that have opted in to immutable subject claims, use a different `sub` claim format that includes numeric owner and repository IDs:

```
repo:<org>@<owner_id>/<repo>@<repo_id>:environment:<environment>
```

The `repository` field in `subject_filters` now accepts both formats:

- Mutable: `org/repo`
- Immutable: `org@owner_id/repo@repo_id`

No variable name changes are required. Update the `repository` value in your `subject_filters` to use the immutable format if your repository has opted in.

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
