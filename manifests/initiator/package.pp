# == Class: iscsi::initiator::package
#
# Manages the iSCSI initiator package on a host.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*ensure*]
#   The desired package state.  This can be `installed` (default), `absent`,
#   or any other value appropriate to the Package resource type.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2017 John Florian


class iscsi::initiator::package (
        Variant[Boolean, String[1]] $ensure = 'installed',
    ) inherits ::iscsi::params {

    package { $::iscsi::params::initiator_packages:
        ensure => $ensure,
        notify => Class['::iscsi::initiator::service'],
    }

}
