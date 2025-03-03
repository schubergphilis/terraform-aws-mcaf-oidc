# terraform-aws-mcaf-oidc

Terraform module to configure an IAM OIDC identity provider in AWS and create roles using this provider.

The root module is generic and can manage any OIDC provider. For easier setup, we also provide submodules for `GitLab` and `GitHub` that extend the root module with pre-configured defaults.

IMPORTANT: We do not pin modules to versions in our examples. We highly recommend that in your code you pin the version to the exact version you are using so that your infrastructure remains stable.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oidc_role"></a> [oidc\_role](#module\_oidc\_role) | schubergphilis/mcaf-role/aws | ~> 0.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_openid_connect_provider.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.default](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | Configuration of the OIDC provider. | <pre>object({<br/>    client_ids     = list(string)<br/>    name           = string<br/>    thumbprint_url = string<br/>    url            = string<br/>  })</pre> | n/a | yes |
| <a name="input_create_oidc_provider"></a> [create\_oidc\_provider](#input\_create\_oidc\_provider) | Toggle to whether or not create the oidc provider. Put to false to not create the oidc provider but instead data source it and create roles only. | `bool` | `true` | no |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | Configuration of the IAM roles, the key of the map is used as the IAM role name. Unless overwritten by setting the name field. | <pre>map(object({<br/>    description              = optional(string, "Role assumed by the IAM OIDC provider")<br/>    name                     = optional(string, null)<br/>    path                     = optional(string, "/")<br/>    permissions_boundary_arn = optional(string, "")<br/>    policy                   = optional(string, null)<br/>    policy_arns              = optional(set(string), [])<br/>    subject_filter           = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles) | Map GitLab OIDC IAM roles name and ARN |
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
