# =============================================================================
# MikroTik Users Module - Integration Tests
# =============================================================================

# Mock provider configuration for testing without real RouterOS device
mock_provider "routeros" {}

# IMPORTANT: terraform-routeros/routeros provider does NOT support user management
# This module is metadata-only for documentation purposes

# Test 1: Module accepts complex configuration
run "complete_user_setup" {
  command = plan
  
  variables {
    user_groups = {
      "monitoring" = {
        policy   = ["read", "test"]
        comment  = "Monitoring group"
      }
      "operators" = {
        policy   = ["read", "write", "test"]
        comment  = "Operators group"
      }
    }
    
    users = {
      "nagios" = {
        group    = "read"
        password = "NagiosPass123!"
        comment  = "Nagios monitoring"
      }
      "operator1" = {
        group    = "write"
        password = "OpPass123!"
        comment  = "Network operator 1"
      }
    }
  }
  
  assert {
    condition     = output.user_count == 0
    error_message = "User count should always be 0 (metadata-only)"
  }
  
  assert {
    condition     = output.user_group_count == 0
    error_message = "Group count should always be 0 (metadata-only)"
  }
}

# Test 2: Module provides documentation note
run "provides_documentation" {
  command = plan
  
  variables {
    users       = {}
    user_groups = {}
  }
  
  assert {
    condition     = output.user_management_note != ""
    error_message = "Should provide user management note"
  }
  
  assert {
    condition     = length(output.usernames) == 0
    error_message = "Usernames list should be empty (metadata-only)"
  }
}
