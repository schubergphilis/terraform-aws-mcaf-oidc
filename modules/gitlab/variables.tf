variable "create_oidc_provider" {
  type        = bool
  default     = true
  description = "Toggle to whether or not create the oidc provider. Put to false to not create the oidc provider but instead data source it and create roles only."
}

variable "oidc_provider" {
  type = object({
    name = optional(string, "GitLab")
    url  = optional(string, "https://gitlab.com")
  })
  default     = {}
  description = "Configuration of the OIDC provider."
}

variable "iam_roles" {
  type = map(object({
    description              = optional(string, "Role assumed by the GitLab IAM OIDC provider")
    name                     = optional(string, null)
    path                     = optional(string, "/")
    permissions_boundary_arn = optional(string, "")
    policy                   = optional(string, null)
    policy_arns              = optional(set(string), [])

    subject_filters = list(object({
      project_path = string
      ref_type     = string
      ref          = string
    }))
  }))

  default     = {}
  description = "Configuration for IAM roles, the key of the map is used as the IAM role name. Unless overwritten by setting the name field."

  validation {
    condition = alltrue([
      for role in values(var.iam_roles) : alltrue([
        for filter in role.subject_filters : can(regex("^(\\*|branch|tag)$", filter.ref_type))
      ])
    ])
    error_message = "For each subject_filter, ref_type must be '*', 'branch', or 'tag'."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to all resources."
}
