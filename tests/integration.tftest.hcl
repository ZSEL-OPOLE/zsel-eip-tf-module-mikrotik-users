# =============================================================================
# MikroTik Users Module - Integration Tests
# =============================================================================

# Test 1: Complete user management setup
run "complete_user_setup" {
  command = plan
  
  variables {
    groups = {
      "monitoring" = {
        name     = "monitoring"
        policies = ["read", "test"]
        comment  = "Monitoring group"
      }
      "operators" = {
        name     = "operators"
        policies = ["read", "write", "test"]
        comment  = "Operators group"
      }
    }
    
    users = {
      "nagios" = {
        name     = "nagios"
        group    = "monitoring"
        password = "NagiosPass123!"
        comment  = "Nagios monitoring"
      }
      "operator1" = {
        name     = "operator1"
        group    = "operators"
        password = "OpPass123!"
        comment  = "Network operator 1"
      }
      "operator2" = {
        name     = "operator2"
        group    = "operators"
        password = "OpPass456!"
        comment  = "Network operator 2"
      }
    }
  }
  
  assert {
    condition     = length(routeros_user_group.this) == 2
    error_message = "Should have 2 groups"
  }
  
  assert {
    condition     = length(routeros_user.this) == 3
    error_message = "Should have 3 users"
  }
}

# Test 2: Multi-site user management
run "multi_site_users" {
  command = plan
  
  variables {
    groups = {
      "site-a-admins" = {
        name     = "site-a-admins"
        policies = ["read", "write", "policy"]
      }
      "site-b-admins" = {
        name     = "site-b-admins"
        policies = ["read", "write", "policy"]
      }
      "monitoring" = {
        name     = "monitoring"
        policies = ["read"]
      }
    }
    
    users = {
      "admin-site-a"  = { name = "admin-site-a", group = "site-a-admins", password = "Pass1!" }
      "admin-site-b"  = { name = "admin-site-b", group = "site-b-admins", password = "Pass2!" }
      "monitoring-1"  = { name = "monitoring-1", group = "monitoring", password = "Mon1!" }
      "monitoring-2"  = { name = "monitoring-2", group = "monitoring", password = "Mon2!" }
    }
  }
  
  assert {
    condition     = length(routeros_user_group.this) == 3
    error_message = "Should have 3 groups"
  }
  
  assert {
    condition     = length(routeros_user.this) == 4
    error_message = "Should have 4 users"
  }
}

# Test 3: Outputs validation
run "outputs_comprehensive" {
  command = plan
  
  variables {
    groups = {
      "group1" = { name = "group1", policies = ["read"] }
      "group2" = { name = "group2", policies = ["read", "write"] }
    }
    
    users = {
      "user1" = { name = "user1", group = "group1", password = "Pass1!" }
    }
  }
  
  assert {
    condition     = output.group_count == 2
    error_message = "Should output 2 groups"
  }
  
  assert {
    condition     = output.user_count == 1
    error_message = "Should output 1 user"
  }
}
