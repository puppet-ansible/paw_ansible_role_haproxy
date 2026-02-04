# paw_ansible_role_haproxy
# @summary Manage paw_ansible_role_haproxy configuration
#
# @param haproxy_socket
# @param haproxy_chroot
# @param haproxy_user
# @param haproxy_group
# @param global_var
# @param haproxy_connect_timeout Default haproxy timeouts
# @param haproxy_client_timeout
# @param haproxy_server_timeout
# @param haproxy_frontend_name Frontend settings.
# @param haproxy_frontend_bind_address
# @param haproxy_frontend_port
# @param haproxy_frontend_mode
# @param haproxy_backend_name Backend settings.
# @param haproxy_backend_mode
# @param haproxy_backend_balance_method
# @param haproxy_backend_httpchk
# @param haproxy_backend_servers List of backend servers.
# @param haproxy_global_vars Extra global vars (see README for example usage).
# @param haproxy_template
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_haproxy (
  String $haproxy_socket = '/var/lib/haproxy/stats',
  String $haproxy_chroot = '/var/lib/haproxy',
  String $haproxy_user = 'haproxy',
  String $haproxy_group = 'haproxy',
  Optional[String] $global_var = undef,
  Integer $haproxy_connect_timeout = 5000,
  Integer $haproxy_client_timeout = 50000,
  Integer $haproxy_server_timeout = 50000,
  String $haproxy_frontend_name = 'hafrontend',
  String $haproxy_frontend_bind_address = '*',
  Integer $haproxy_frontend_port = 80,
  String $haproxy_frontend_mode = 'http',
  String $haproxy_backend_name = 'habackend',
  String $haproxy_backend_mode = 'http',
  String $haproxy_backend_balance_method = 'roundrobin',
  String $haproxy_backend_httpchk = 'HEAD / HTTP/1.1\\r\\nHost:localhost',
  Array $haproxy_backend_servers = [],
  Array $haproxy_global_vars = [],
  String $haproxy_template = 'haproxy.cfg.j2',
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
$_par_vardir = $par_vardir ? {
  undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
  default => $par_vardir,
}
$playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_haproxy/playbook.yml"

par { 'paw_ansible_role_haproxy-main':
  ensure        => present,
  playbook      => $playbook_path,
  playbook_vars => {
        'haproxy_socket' => $haproxy_socket,
        'haproxy_chroot' => $haproxy_chroot,
        'haproxy_user' => $haproxy_user,
        'haproxy_group' => $haproxy_group,
        'global_var' => $global_var,
        'haproxy_connect_timeout' => $haproxy_connect_timeout,
        'haproxy_client_timeout' => $haproxy_client_timeout,
        'haproxy_server_timeout' => $haproxy_server_timeout,
        'haproxy_frontend_name' => $haproxy_frontend_name,
        'haproxy_frontend_bind_address' => $haproxy_frontend_bind_address,
        'haproxy_frontend_port' => $haproxy_frontend_port,
        'haproxy_frontend_mode' => $haproxy_frontend_mode,
        'haproxy_backend_name' => $haproxy_backend_name,
        'haproxy_backend_mode' => $haproxy_backend_mode,
        'haproxy_backend_balance_method' => $haproxy_backend_balance_method,
        'haproxy_backend_httpchk' => $haproxy_backend_httpchk,
        'haproxy_backend_servers' => $haproxy_backend_servers,
        'haproxy_global_vars' => $haproxy_global_vars,
        'haproxy_template' => $haproxy_template
              },
  tags          => $par_tags,
  skip_tags     => $par_skip_tags,
  start_at_task => $par_start_at_task,
  limit         => $par_limit,
  verbose       => $par_verbose,
  check_mode    => $par_check_mode,
  timeout       => $par_timeout,
  user          => $par_user,
  env_vars      => $par_env_vars,
  logoutput     => $par_logoutput,
  exclusive     => $par_exclusive,
}
}
