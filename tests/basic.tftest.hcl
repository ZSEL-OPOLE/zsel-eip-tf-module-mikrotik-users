# =============================================================================
# MikroTik Users Module - Basic Functionality Tests
# =============================================================================

# Mock provider configuration for testing without real RouterOS device
mock_provider "routeros" {}

# IMPORTANT: terraform-routeros/routeros provider does NOT support user management
# This module is metadata-only for documentation purposes

# Test 1: Module accepts user configuration (metadata only)
run "accepts_user_config" {
  command = plan
  
  variables {
    users = {
      "monitoring-user" = {
        group    = "read"
        password = "SecurePass123!"
        comment  = "Monitoring account"
      }
    }
  }
  
  assert {
    condition     = output.user_management_note != ""
    error_message = "Should provide management note"
  }
  
  assert {
    condition     = output.user_count == 0
    error_message = "User count should always be 0 (metadata-only)"
  }
}

# Test 2: Module accepts group configuration (metadata only)
run "accepts_group_config" {
  command = plan
  
  variables {
    user_groups = {
      "monitoring" = {
        policy   = ["read", "test"]
        comment  = "Monitoring group"
      }
    }
  }
  
  assert {
    condition     = output.user_group_count == 0
    error_message = "Group count should always be 0 (metadata-only)"
  }
}

# Test 3: Empty configuration works
run "empty_config" {
  command = plan
  
  variables {
    users       = {}
    user_groups = {}
  }
  
  assert {
    condition     = output.user_count == 0
    error_message = "User count should be 0"
  }
}
