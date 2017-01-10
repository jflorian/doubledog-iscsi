# == Class: iscsi::target::service
#
# Manages the iSCSI target service on a host.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'running' (default) or 'stopped'.  Alternatively,
#   a Boolean value may also be used with true equivalent to 'running' and
#   false equivalent to 'stopped'.
#
# [*manage_firewall*]
#   Whether to manage the firewall or not.  Defaults to true.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


class iscsi::target::service (
        Variant[Boolean, Enum['running', 'stopped']] $ensure='running',
        Boolean $manage_firewall=true,
    ) inherits ::iscsi::params {

    package { $::iscsi::params::target_packages:
        ensure => installed,
        notify => Service[$::iscsi::params::target_services],
    }

    if $manage_firewall {
        firewall { '500 accept iSCSI target packets':
            dport  => '3260',
            proto  => 'tcp',
            state  => 'NEW',
            action => 'accept',
        }
    }

    service { $::iscsi::params::target_services:
        ensure     => $ensure,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
    }

}
