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
# [*enable*]
#   Instance is to be started at boot.  Either true (default) or false.
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
        Boolean $enable=true,
        Variant[Boolean, Enum['running', 'stopped']] $ensure='running',
    ) inherits ::iscsi::params {

    include '::iscsi::initiator::package'

    service { $::iscsi::params::initiator_services:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}
