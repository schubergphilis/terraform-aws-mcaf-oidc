<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_default"></a> [default](#module\_default) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_oidc_provider"></a> [create\_oidc\_provider](#input\_create\_oidc\_provider) | Toggle to whether or not create the oidc provider. Put to false to not create the oidc provider but instead data source it and create roles only. | `bool` | `true` | no |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | Configuration for IAM roles, the key of the map is used as the IAM role name. Unless overwritten by setting the name field. | <pre>map(object({<br/>    description              = optional(string, "Role assumed by the GitLab IAM OIDC provider")<br/>    name                     = optional(string, null)<br/>    path                     = optional(string, "/")<br/>    permissions_boundary_arn = optional(string, "")<br/>    policy                   = optional(string, null)<br/>    policy_arns              = optional(set(string), [])<br/><br/>    subject_filters = list(object({<br/>      project_path = string<br/>      ref_type     = string<br/>      ref          = string<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | Configuration of the OIDC provider. | <pre>object({<br/>    url = optional(string, "https://gitlab.com")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles) | Map GitHub OIDC IAM roles name and ARN |
<!-- END_TF_DOCS -->
