# =============================================================================
# MikroTik Users Module - Validation Tests
# =============================================================================

# Mock provider configuration for testing without real RouterOS device
mock_provider "routeros" {}

# IMPORTANT: terraform-routeros/routeros provider does NOT support user management
# This module is metadata-only for documentation purposes

# Test 1: Module accepts valid configuration
run "valid_config" {
  command = plan
  
  variables {
    users = {
      "admin-user" = {
        group    = "full"
        password = "SecurePass123!"
      }
    }
  }
  
  assert {
    condition     = output.user_count == 0
    error_message = "User count should always be 0 (metadata-only)"
  }
}

# Test 2: Module accepts empty configuration
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
  
  assert {
    condition     = output.user_group_count == 0
    error_message = "Group count should be 0"
  }
}
