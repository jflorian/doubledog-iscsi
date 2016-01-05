# == Class: iscsi::initiator::service
#
# Manages the iSCSI initiator service on a host.
#
# === Parameters
#
# [*ensure*]
#   Instance is to be 'running' (default) or 'stopped'.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2016 John Florian


class iscsi::initiator::service (
        $ensure='running',
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
