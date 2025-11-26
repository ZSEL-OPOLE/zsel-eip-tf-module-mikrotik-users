# MikroTik Users Module

Universal Terraform module for managing user accounts and groups on MikroTik RouterOS using the `lkolo-prez/mikrotik` provider.

## Features

- **User Account Management**: Create/manage local user accounts with passwords
- **Custom User Groups**: Define groups with specific policy permissions
- **Password Validation**: Minimum 8 characters required
- **Security Best Practice**: Optionally disable factory default `admin` user
- **Sensitive Data**: Passwords marked as sensitive (not shown in logs)
- **Production Ready**: Suitable for 1 device or 57+ devices with centralized IAM

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| mikrotik | >= 1.0 |

## Resources Created

- `routeros_user` - User accounts
- `routeros_user_group` - User groups (optional, uses built-in groups by default)

## Usage Examples

### Example 1: Basic User Accounts (Built-in Groups)

```hcl
module "users" {
  source = "./modules/mikrotik/users"
  
  users = {
    "admin-it" = {
      password = "SecureP@ssw0rd123!"
      group    = "full"
      comment  = "IT Administrator (full access)"
    }
    "operator-noc" = {
      password = "N0cOperator2024"
      group    = "write"
      comment  = "NOC Operator (read+write)"
    }
    "readonly-audit" = {
      password = "Aud1tRead2024"
      group    = "read"
      comment  = "Audit user (read-only)"
    }
  }
  
  # Disable factory default admin user (security best practice)
  disable_default_admin = true
}
```

### Example 2: Multi-Administrator (57 Devices - ZSEL Opole)

```hcl
module "users" {
  source = "./modules/mikrotik/users"
  
  users = {
    "admin-lukasz" = {
      password = "Luk@sz$ecur3!2024"
      group    = "full"
      address  = "192.168.600.10"  # Restrict to management workstation
      comment  = "Lukasz - Lead Network Admin"
    }
    "admin-marcin" = {
      password = "M@rc1nAdm!n2024"
      group    = "full"
      address  = "192.168.600.11"
      comment  = "Marcin - System Administrator"
    }
    "operator-helpdesk" = {
      password = "H3lpD3sk!2024"
      group    = "write"
      address  = "192.168.500.0/24"  # Allow from admin VLAN
      comment  = "Helpdesk Operator (limited write)"
    }
    "monitor-prometheus" = {
      password = "Pr0m3th3u$Mon!2024"
      group    = "read"
      address  = "192.168.10.100"  # K3s monitoring pod
      comment  = "Prometheus SNMP monitoring (read-only)"
    }
  }
  
  disable_default_admin = true
}
```

### Example 3: Custom User Groups with Policies

```hcl
module "users" {
  source = "./modules/mikrotik/users"
  
  # Define custom user groups with specific policies
  user_groups = {
    "api-automation" = {
      policy  = ["read", "write", "api", "test"]
      comment = "Automation scripts (API access, no sensitive data)"
    }
    "backup-scripts" = {
      policy  = ["read", "ssh", "ftp"]
      comment = "Backup scripts (read config, no changes)"
    }
    "monitoring-only" = {
      policy  = ["read", "sniff", "test"]
      comment = "Monitoring tools (SNMP, diagnostics)"
    }
  }
  
  users = {
    "api-terraform" = {
      password = "T3rr@f0rmAP!2024"
      group    = "api-automation"
      address  = "192.168.10.0/24"  # K3s cluster
      comment  = "Terraform provider automation"
    }
    "backup-ansible" = {
      password = "An$ibl3B@ckup2024"
      group    = "backup-scripts"
      address  = "192.168.10.50"
      comment  = "Ansible backup playbooks"
    }
    "monitor-nagios" = {
      password = "N@g10sMon!2024"
      group    = "monitoring-only"
      address  = "192.168.10.60"
      comment  = "Nagios SNMP monitoring"
    }
  }
  
  disable_default_admin = true
}
```

### Example 4: ISP Customer Access (Limited)

```hcl
module "users" {
  source = "./modules/mikrotik/users"
  
  users = {
    "customer-acme-corp" = {
      password = "AcmeC0rp!2024"
      group    = "read"
      address  = "203.0.113.0/24"  # Customer public IP range
      comment  = "ACME Corp - Read-only access to their config"
    }
    "customer-widgets-inc" = {
      password = "W!dg3tsInc2024"
      group    = "read"
      address  = "198.51.100.0/24"
      comment  = "Widgets Inc - Read-only access"
    }
  }
}
```

### Example 5: Time-Based Access (VPN Users)

```hcl
module "users" {
  source = "./modules/mikrotik/users"
  
  users = {
    "vpn-contractor-john" = {
      password = "J0hn!Contr@ct2024"
      group    = "write"
      address  = "192.168.50.0/24"  # VPN VLAN
      comment  = "John (Contractor) - VPN access until 2025-03-31"
    }
    "vpn-remote-sales" = {
      password = "S@lesTeam!2024"
      group    = "read"
      address  = "192.168.50.0/24"
      comment  = "Remote sales team - VPN read-only"
    }
  }
}
```

### Example 6: Factory Reset Router (Single Admin)

```hcl
module "users" {
  source = "./modules/mikrotik/users"
  
  users = {
    "admin" = {
      password = "Ch@ngeM3N0w!2024"
      group    = "full"
      comment  = "Primary administrator (change password after first login!)"
    }
  }
  
  # Keep default admin enabled until new admin is verified
  disable_default_admin = false
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `users` | User accounts to create | `map(object)` | `{}` | no |
| `user_groups` | Custom user groups with policies | `map(object)` | `{}` | no |
| `disable_default_admin` | Disable factory default 'admin' user | `bool` | `false` | no |

### users object

| Field | Type | Required | Description | Validation |
|-------|------|----------|-------------|------------|
| `password` | `string` | yes | User password | Min 8 characters |
| `group` | `string` | yes | User group (`full`, `read`, `write`, or custom) | Must exist |
| `address` | `string` | no | Restrict access from specific IP/subnet | - |
| `comment` | `string` | no | Description for this user | - |
| `disabled` | `bool` | no | Disable this user account | Default: `false` |

### user_groups object

| Field | Type | Required | Description | Validation |
|-------|------|----------|-------------|------------|
| `policy` | `list(string)` | yes | List of policies (see table below) | At least 1 policy required |
| `comment` | `string` | no | Description for this group | - |

## Built-in User Groups

| Group | Policies | Description | Use Case |
|-------|----------|-------------|----------|
| `full` | all | Full access (superuser) | Primary administrators |
| `write` | read, write, test | Read/write without sensitive data | Operators, NOC staff |
| `read` | read | Read-only access | Monitoring, auditing, customers |

## User Policy Reference

| Policy | Description | Permissions |
|--------|-------------|-------------|
| `read` | Read-only access | View config, stats, logs (no changes) |
| `write` | Write access | Modify config (except sensitive data) |
| `policy` | Policy management | Create/modify firewall, NAT, routes |
| `test` | Testing tools | Ping, traceroute, bandwidth test |
| `password` | Password management | Change own password |
| `web` | WebFig access | Access web interface (port 80/443) |
| `sniff` | Packet sniffing | Use packet sniffer, torch |
| `sensitive` | Sensitive data | View/modify passwords, SNMP communities |
| `api` | API access | Use REST API, Winbox API |
| `romon` | RoMON access | Remote monitoring neighbor access |
| `dude` | The Dude access | Access from The Dude monitoring |
| `tikapp` | Tik-App access | Access from mobile app |
| `ftp` | FTP access | Upload/download files via FTP |
| `reboot` | Reboot router | Power cycle device |
| `telnet` | Telnet access | Connect via Telnet (not SSH) |
| `ssh` | SSH access | Connect via SSH |

## Outputs

| Name | Description |
|------|-------------|
| `users` | Map of created user accounts (passwords redacted) |
| `user_groups` | Map of created user groups |
| `user_count` | Total number of users |
| `group_count` | Total number of custom groups |

## Security Best Practices

1. **Strong Passwords**: Minimum 8 characters, use uppercase, lowercase, numbers, special chars
2. **Disable Default Admin**: Always disable factory `admin` user after creating new admin
3. **Restrict by IP**: Use `address` field to limit access from specific IPs/subnets
4. **Principle of Least Privilege**: Use `read` or `write` groups, avoid `full` for operators
5. **Separate Accounts**: Create individual accounts per person (no shared passwords)
6. **Regular Audits**: Review user accounts quarterly, disable unused accounts
7. **Monitoring Accounts**: Use `read`-only for SNMP/monitoring tools
8. **API Accounts**: Create dedicated users for Terraform/Ansible (not `full` group)
9. **Rotate Passwords**: Change passwords every 90 days (compliance requirement)
10. **Two-Factor Auth**: Use RADIUS/TACACS+ for centralized authentication (not in this module)

## Password Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| Length | 8 characters | 16+ characters |
| Uppercase | 1 | 2+ |
| Lowercase | 1 | 2+ |
| Numbers | 1 | 2+ |
| Special chars | 1 | 2+ |
| Examples | `MyP@ss12` | `C0mpl3x!P@ssw0rd2024#` |

## Centralized Authentication (RADIUS)

For enterprise environments with 57+ devices, consider using RADIUS instead:

```hcl
# Not part of this module - separate RADIUS configuration
resource "routeros_radius" "main" {
  address = "192.168.10.100"
  secret  = "radius-shared-secret"
  service = "login"
}
```

Benefits:
- Centralized user management (FreeIPA, Active Directory, LDAP)
- Single password change updates all 57 routers
- Two-factor authentication (OTP, SMS)
- Better audit logging

## Integration with Other Modules

This module should be configured **before**:

- **firewall** - Reference user groups in firewall rules
- **system** - Logging configuration for user actions

This module works with:

- **ip-addressing** - Restrict users to specific VLANs/IPs
- **interfaces** - Manage users after network is configured

## Migration from Manual Configuration

Export existing users:

```bash
/user export
/user group export
```

Convert to Terraform format, then import:

```bash
terraform import 'module.users.routeros_user.this["admin-it"]' 'admin-it'
```

**⚠️ WARNING**: Importing users does NOT import passwords. You must set passwords in Terraform variables.

## Troubleshooting

### Cannot SSH After Disabling Default Admin

**Problem**: Locked out after `disable_default_admin = true`

**Solution**: 
1. Use Winbox (MAC address connection) to bypass IP auth
2. Re-enable default admin or create new admin user
3. ALWAYS create new admin BEFORE disabling default admin

### User Cannot Access Winbox

**Problem**: User created but cannot connect via Winbox

**Solution**: Verify user has `policy` or `api` permission in group

### Password Too Weak Error

**Problem**: `password must be at least 8 characters`

**Solution**: Use stronger password (8+ chars, mixed case, numbers, specials)

### User Address Restriction Not Working

**Problem**: User can connect from any IP despite `address` restriction

**Solution**: Verify firewall rules allow connections only from specified IPs

## Example: Full User Lifecycle

```hcl
# Step 1: Create new admin (keep default admin enabled)
module "users_initial" {
  source = "./modules/mikrotik/users"
  
  users = {
    "admin-new" = {
      password = "N3wAdm!n2024"
      group    = "full"
      comment  = "New admin account"
    }
  }
  
  disable_default_admin = false  # Keep default admin
}

# Step 2: Test new admin access
# - SSH as admin-new
# - Verify full access
# - Test Winbox connection

# Step 3: Disable default admin (after verification)
module "users_final" {
  source = "./modules/mikrotik/users"
  
  users = {
    "admin-new" = {
      password = "N3wAdm!n2024"
      group    = "full"
      comment  = "New admin account (verified)"
    }
  }
  
  disable_default_admin = true  # NOW safe to disable
}
```

## License

MIT License

## Author

Created for universal MikroTik RouterOS automation using Terraform.

## Version

Module version: **1.0.0**  
Compatible with: **MikroTik RouterOS v7.16+**  
Terraform provider: **lkolo-prez/mikrotik >= 1.0**
