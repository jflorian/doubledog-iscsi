# == Class: iscsi::initiator::service
#
# Manages the iSCSI initiator service on a host.
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
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


class iscsi::initiator::service (
        Variant[Boolean, Enum['running', 'stopped']] $ensure='running',
    ) inherits ::iscsi::params {

    package { $::iscsi::params::initiator_packages:
        ensure => installed,
        notify => Service[$::iscsi::params::initiator_services],
    }

    service { $::iscsi::params::initiator_services:
        ensure     => $ensure,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
    }

}
