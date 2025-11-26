# ===== USER ACCOUNTS =====
# IMPORTANT: terraform-routeros/routeros provider does NOT support user management resources
# Users must be managed manually via:
# - RouterOS CLI: /user add name=username password=password group=groupname
# - WinBox: System -> Users
# - WebFig: System -> Users
#
# Alternative: Use Ansible for user management with community.routeros collection
#
# resource "routeros_user" "this" {
#   for_each = var.users
#   
#   name     = each.key
#   password = each.value.password
#   group    = each.value.group
#   address  = lookup(each.value, "address", null)
#   comment  = lookup(each.value, "comment", null)
#   disabled = lookup(each.value, "disabled", false)
# }

# ===== USER GROUPS =====
# IMPORTANT: terraform-routeros/routeros provider does NOT support user group management
# resource "routeros_user_group" "this" {
#   for_each = var.user_groups
#   
#   name   = each.key
#   policy = each.value.policy
#   comment = lookup(each.value, "comment", null)
# }

# ===== WORKAROUND: Use null_resource with local-exec =====
# This is a workaround to manage users via RouterOS API/CLI
# Uncomment if you want to use this approach:
#
# resource "null_resource" "users" {
#   for_each = var.users
#   
#   provisioner "local-exec" {
#     command = <<-EOT
#       # Example: Use RouterOS API or SSH to create users
#       # ssh admin@${var.mikrotik_host} '/user add name=${each.key} password=${each.value.password} group=${each.value.group}'
#     EOT
#   }
# }
