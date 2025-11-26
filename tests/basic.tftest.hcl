# =============================================================================
# MikroTik Users Module - Basic Functionality Tests
# =============================================================================

# Test 1: Single user
run "single_user" {
  command = plan
  
  variables {
    users = {
      "monitoring-user" = {
        name     = "monitoring-user"
        group    = "read"
        password = "SecurePass123!"
        comment  = "Monitoring account"
      }
    }
  }
  
  assert {
    condition     = routeros_user.this["monitoring-user"].name == "monitoring-user"
    error_message = "User name should match"
  }
  
  assert {
    condition     = routeros_user.this["monitoring-user"].group == "read"
    error_message = "User should be in read group"
  }
}

# Test 2: Single group
run "single_group" {
  command = plan
  
  variables {
    groups = {
      "monitoring" = {
        name     = "monitoring"
        policies = ["read", "test"]
        comment  = "Monitoring group"
      }
    }
  }
  
  assert {
    condition     = routeros_user_group.this["monitoring"].name == "monitoring"
    error_message = "Group name should match"
  }
  
  assert {
    condition     = contains(routeros_user_group.this["monitoring"].policy, "read")
    error_message = "Group should have read policy"
  }
}

# Test 3: No resources created
run "no_resources_created" {
  command = plan
  
  variables {
    users  = {}
    groups = {}
  }
  
  assert {
    condition     = length(routeros_user.this) == 0
    error_message = "No users should be created"
  }
  
  assert {
    condition     = length(routeros_user_group.this) == 0
    error_message = "No groups should be created"
  }
}
