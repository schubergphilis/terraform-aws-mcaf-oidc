variable "create_oidc_provider" {
  type        = bool
  default     = true
  description = "Toggle to whether or not create the oidc provider. Put to false to not create the oidc provider but instead data source it and create roles only."
}

variable "oidc_provider" {
  type = object({
    client_ids     = optional(list(string), ["sts.amazonaws.com"])
    name           = optional(string, "GitHub")
    thumbprint_url = optional(string, "https://token.actions.githubusercontent.com/.well-known/openid-configuration")
    url            = optional(string, "https://token.actions.githubusercontent.com")
  })
  default     = {}
  description = "Configuration of the OIDC provider."
}

variable "iam_roles" {
  type = map(object({
    description              = optional(string, "Role assumed by the GitHub IAM OIDC provider")
    name                     = optional(string, null)
    path                     = optional(string, "/")
    permissions_boundary_arn = optional(string, "")
    policy                   = optional(string, null)
    policy_arns              = optional(set(string), [])

    subject_filter = object({
      repository  = string
      branch      = optional(string)
      environment = optional(string)
      tag         = optional(string)
    })
  }))

  default     = {}
  description = "Configuration for IAM roles, the key of the map is used as the IAM role name. Unless overwritten by setting the name field."

  validation {
    condition = alltrue([
      for role in values(var.iam_roles) : (length(compact([
        role.subject_filter.branch != null ? role.subject_filter.branch : null,
        role.subject_filter.environment != null ? role.subject_filter.environment : null,
        role.subject_filter.tag != null ? role.subject_filter.tag : null
        ])) == 1
      )
    ])
    error_message = "For subject_filter, exactly one of branch, environment, or tag must be specified."
  }

  validation {
    condition = alltrue([
      for role in values(var.iam_roles) : (length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/\\-\\*]+)$", role.subject_filter.repository)) > 0
      )
    ])
    error_message = "For subject_filter, the repository must be in the organization/repository format."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to all resources."
}
