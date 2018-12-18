# == Class: iscsi::initiator::package
#
# Manages the iSCSI initiator package on a host.
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

    include '::iscsi::initiator::service'

    package { $names:
        ensure => $ensure,
        notify => Class['::iscsi::initiator::service'],
    }

}
