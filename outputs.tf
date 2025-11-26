# ===== OUTPUTS =====
# IMPORTANT: User management resources are not supported by terraform-routeros/routeros
# These outputs are disabled as the resources don't exist

# output "users" {
#   description = "Configured user accounts"
#   value = {
#     for k, v in routeros_user.this :
#     k => {
#       name     = v.name
#       group    = v.group
#       disabled = v.disabled
#     }
#   }
#   sensitive = true
# }

# output "user_groups" {
#   description = "Configured user groups"
#   value = {
#     for k, v in routeros_user_group.this :
#     k => {
#       name   = v.name
#       policy = v.policy
#     }
#   }
# }

output "user_management_note" {
  description = "Important note about user management"
  value       = "User management is not supported by terraform-routeros/routeros provider. Configure users manually via RouterOS CLI/WinBox or use Ansible."
}

output "user_count" {
  description = "Total number of users (always 0 - managed manually)"
  value       = 0
}

output "user_group_count" {
  description = "Total number of user groups (always 0 - managed manually)"
  value       = 0
}

output "usernames" {
  description = "List of configured usernames"
  value       = keys(routeros_user.this)
  sensitive   = true
}
