# Example usage of paw_ansible_role_haproxy

# Simple include with default parameters
include paw_ansible_role_haproxy

# Or with custom parameters:
# class { 'paw_ansible_role_haproxy':
#   haproxy_socket => '/var/lib/haproxy/stats',
#   haproxy_chroot => '/var/lib/haproxy',
#   haproxy_user => 'haproxy',
#   haproxy_group => 'haproxy',
#   global_var => undef,
#   haproxy_connect_timeout => 5000,
#   haproxy_client_timeout => 50000,
#   haproxy_server_timeout => 50000,
#   haproxy_frontend_name => 'hafrontend',
#   haproxy_frontend_bind_address => '*',
#   haproxy_frontend_port => 80,
#   haproxy_frontend_mode => 'http',
#   haproxy_backend_name => 'habackend',
#   haproxy_backend_mode => 'http',
#   haproxy_backend_balance_method => 'roundrobin',
#   haproxy_backend_httpchk => 'HEAD / HTTP/1.1\\r\\nHost:localhost',
#   haproxy_backend_servers => [],
#   haproxy_global_vars => [],
#   haproxy_template => 'haproxy.cfg.j2',
# }
