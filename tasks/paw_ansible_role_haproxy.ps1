# Puppet task for executing Ansible role: ansible_role_haproxy
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_haproxy"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_haproxy"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_haproxy\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_haproxy"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_haproxy"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_haproxy_socket) {
  $ExtraVars['haproxy_socket'] = $env:PT_haproxy_socket
}
if ($env:PT_haproxy_chroot) {
  $ExtraVars['haproxy_chroot'] = $env:PT_haproxy_chroot
}
if ($env:PT_haproxy_user) {
  $ExtraVars['haproxy_user'] = $env:PT_haproxy_user
}
if ($env:PT_haproxy_group) {
  $ExtraVars['haproxy_group'] = $env:PT_haproxy_group
}
if ($env:PT_global_var) {
  $ExtraVars['global_var'] = $env:PT_global_var
}
if ($env:PT_haproxy_connect_timeout) {
  $ExtraVars['haproxy_connect_timeout'] = $env:PT_haproxy_connect_timeout
}
if ($env:PT_haproxy_client_timeout) {
  $ExtraVars['haproxy_client_timeout'] = $env:PT_haproxy_client_timeout
}
if ($env:PT_haproxy_server_timeout) {
  $ExtraVars['haproxy_server_timeout'] = $env:PT_haproxy_server_timeout
}
if ($env:PT_haproxy_frontend_name) {
  $ExtraVars['haproxy_frontend_name'] = $env:PT_haproxy_frontend_name
}
if ($env:PT_haproxy_frontend_bind_address) {
  $ExtraVars['haproxy_frontend_bind_address'] = $env:PT_haproxy_frontend_bind_address
}
if ($env:PT_haproxy_frontend_port) {
  $ExtraVars['haproxy_frontend_port'] = $env:PT_haproxy_frontend_port
}
if ($env:PT_haproxy_frontend_mode) {
  $ExtraVars['haproxy_frontend_mode'] = $env:PT_haproxy_frontend_mode
}
if ($env:PT_haproxy_backend_name) {
  $ExtraVars['haproxy_backend_name'] = $env:PT_haproxy_backend_name
}
if ($env:PT_haproxy_backend_mode) {
  $ExtraVars['haproxy_backend_mode'] = $env:PT_haproxy_backend_mode
}
if ($env:PT_haproxy_backend_balance_method) {
  $ExtraVars['haproxy_backend_balance_method'] = $env:PT_haproxy_backend_balance_method
}
if ($env:PT_haproxy_backend_httpchk) {
  $ExtraVars['haproxy_backend_httpchk'] = $env:PT_haproxy_backend_httpchk
}
if ($env:PT_haproxy_backend_servers) {
  $ExtraVars['haproxy_backend_servers'] = $env:PT_haproxy_backend_servers
}
if ($env:PT_haproxy_global_vars) {
  $ExtraVars['haproxy_global_vars'] = $env:PT_haproxy_global_vars
}
if ($env:PT_haproxy_template) {
  $ExtraVars['haproxy_template'] = $env:PT_haproxy_template
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_haproxy"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_haproxy"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
