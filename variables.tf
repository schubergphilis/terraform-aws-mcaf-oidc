variable "create_oidc_provider" {
  type        = bool
  default     = true
  description = "Toggle to whether or not create the oidc provider. Put to false to not create the oidc provider but instead data source it and create roles only."
}

variable "oidc_provider" {
  type = object({
    client_ids     = list(string)
    name           = string
    thumbprint_url = string
    url            = string
  })
  description = "Configuration of the OIDC provider."

  validation {
    condition     = can(regex("^https", var.oidc_provider.url))
    error_message = "URL should start with 'https'."
  }
}

variable "iam_roles" {
  type = map(object({
    description              = optional(string, "Role assumed by the IAM OIDC provider")
    name                     = optional(string, null)
    path                     = optional(string, "/")
    permissions_boundary_arn = optional(string, "")
    policy                   = optional(string, null)
    policy_arns              = optional(set(string), [])
    subject_filters          = list(string)
  }))
  default     = {}
  description = "Configuration of the IAM roles, the key of the map is used as the IAM role name. Unless overwritten by setting the name field."

}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to all resources."
}
