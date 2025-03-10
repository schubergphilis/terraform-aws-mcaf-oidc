variable "create_oidc_provider" {
  type        = bool
  default     = true
  description = "Toggle to whether or not create the oidc provider. Put to false to not create the oidc provider but instead data source it and create roles only."
}

variable "oidc_provider" {
  type = object({
    client_ids     = optional(list(string), ["https://gitlab.com"])
    name           = optional(string, "GitLab")
    thumbprint_url = optional(string, "https://gitlab.com")
    url            = optional(string, "https://gitlab.com")
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

    subject_filter = object({
      project_path = string
      ref_type     = string
      ref          = string
    })
  }))

  default     = {}
  description = "Configuration for IAM roles, the key of the map is used as the IAM role name. Unless overwritten by setting the name field."

  validation {
    condition     = alltrue([for o in var.iam_roles : can(regex("^(\\*|branch|tag)$", o.subject_filter.ref_type))])
    error_message = "ref_type must be '*', 'branch', or 'tag'."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to all resources."
}
