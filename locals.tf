# ===== USER SUMMARIES =====
locals {
  # Users by group
  users_by_group = {
    for group in distinct([for k, v in var.users : v.group]) :
    group => [for k, v in var.users : k if v.group == group]
  }
  
  # Active vs disabled users
  user_status = {
    active   = length([for k, v in var.users : k if !lookup(v, "disabled", false)])
    disabled = length([for k, v in var.users : k if lookup(v, "disabled", false)])
  }
  
  # Users with IP restrictions
  users_with_ip_restriction = length([
    for k, v in var.users :
    k if lookup(v, "address", null) != null
  ])
  
  # Security recommendations
  security_check = {
    weak_passwords = length([
      for k, v in var.users :
      k if length(v.password) < 12
    ])
    should_disable_default_admin = var.disable_default_admin
  }
  
  # Module metadata
  module_info = {
    name    = "users"
    version = "1.0.0"
    purpose = "Universal user management for MikroTik RouterOS"
  }
}
