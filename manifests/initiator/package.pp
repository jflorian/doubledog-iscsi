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
# [*names*]
#   An array of package names needed for the initiator installation.  The
#   default should be correct for supported platforms.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2017 John Florian


class iscsi::initiator::package (
        Variant[Boolean, String[1]] $ensure,
        Array[String[1], 1]         $names,
    ) {

    package { $names:
        ensure => $ensure,
        notify => Class['::iscsi::initiator::service'],
    }

}
