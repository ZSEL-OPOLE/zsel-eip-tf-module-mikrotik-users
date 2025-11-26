# =============================================================================
# MikroTik Users Module - Validation Tests
# =============================================================================

# Test 1: Valid username
run "valid_username" {
  command = plan
  
  variables {
    users = {
      "admin-user" = {
        name  = "admin-user"
        group = "full"
      }
    }
  }
  
  assert {
    condition     = var.users["admin-user"].name == "admin-user"
    error_message = "Username should match"
  }
}

# Test 2: Valid group
run "valid_group" {
  command = plan
  
  variables {
    groups = {
      "monitoring" = {
        name     = "monitoring"
        policies = ["read", "test"]
      }
    }
  }
  
  assert {
    condition     = var.groups["monitoring"].name == "monitoring"
    error_message = "Group name should match"
  }
}

# Test 3: Valid policies
run "valid_policies" {
  command = plan
  
  variables {
    groups = {
      "custom" = {
        name     = "custom"
        policies = ["read", "write", "policy"]
      }
    }
  }
  
  assert {
    condition     = length(var.groups["custom"].policies) == 3
    error_message = "Should have 3 policies"
  }
}
