# /etc/dovecot/dovecot.conf

# Protocols to enable
protocols = imap pop3

# Disable plaintext authentication (already set above, no need to repeat)
# disable_plaintext_auth = yes

# Enable SSL/TLS
ssl = yes
ssl_cert = </etc/ssl/certs/your_cert.pem
ssl_key = </etc/ssl/private/your_key.pem

# Force secure connections
ssl_protocols = !SSLv2 !SSLv3

# Set security options
login_trusted_networks = x.x.x.x/xx  # Replace with your trusted network
mail_access_groups = mail

# Limit IMAP and POP3 processes
service imap {
  process_limit = 256
}

service pop3 {
  process_limit = 256
}

# Disable unnecessary plugins
# Only one disable_plaintext_auth line is needed
disable_plaintext_auth = yes
auth_mechanisms = plain login

# Enable mail location and home directories
mail_location = maildir:/var/mail/%u
userdb {
  driver = passwd
}

# Enable logging
log_path = /var/log/dovecot.log
info_log_path = /var/log/dovecot-info.log

# Set user privileges
first_valid_uid = 1000
last_valid_uid = 2000
first_valid_gid = 1000
last_valid_gid = 2000

# Additional security measures
protocol imap {
  mail_max_userip_connections = 10
}

protocol pop3 {
  mail_max_userip_connections = 10
}

# Specify authentication mechanisms
auth_username_format = %Lu
auth_verbose = yes
auth_debug = yes

# Limit maximum authentication attempts
auth_max_failed_requests = 3

# Allow SSLv3 only for old clients (consider removing, SSLv3 is outdated)
ssl_dh_parameters_length = 2048
ssl_cipher_list = ALL:!LOW:!SSLv2:!SSLv3

# Log file settings
log_timestamp = "%Y-%m-%d %H:%M:%S "
syslog_facility = mail

# Disable unnecessary protocols
!include_try /usr/share/dovecot/protocols.d/*.protocol

# RoundCubeMail specific settings
plugin {
  # RoundCubeMail IMAP settings
  sieve = ~/.dovecot.sieve
  sieve_default = /var/mail/%u/dovecot.sieve
  sieve_dir = /var/mail/%u/sieve

  # RoundCubeMail password change plugin
  password = passwd-file
  passwd-file {
    args = scheme=SHA512-CRYPT username_format=%n /etc/dovecot/users
  }
}

# RoundCubeMail authentication
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
  }

  # RoundCubeMail authentication socket
  user = postfix
}
