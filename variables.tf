# ===== USER ACCOUNTS =====
variable "users" {
  description = "User accounts to create"
  type = map(object({
    password = string
    group    = string
    address  = optional(string)
    comment  = optional(string)
    disabled = optional(bool, false)
  }))
  default = {}
  sensitive = true
  
  validation {
    condition = alltrue([
      for k, v in var.users :
      length(v.password) >= 8
    ])
    error_message = "User password must be at least 8 characters."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.users :
      contains(["full", "read", "write"], v.group)
    ])
    error_message = "User group must be one of: full, read, write."
  }
}

# ===== USER GROUPS =====
variable "user_groups" {
  description = "Custom user groups with specific policies"
  type = map(object({
    policy  = list(string)
    comment = optional(string)
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for k, v in var.user_groups :
      length(v.policy) > 0
    ])
    error_message = "User group must have at least one policy."
  }
}

# ===== DISABLE DEFAULT ADMIN =====
variable "disable_default_admin" {
  description = "Disable factory default 'admin' user (security best practice)"
  type        = bool
  default     = false
}
