# == Class: iscsi::target::package
#
# Manages the iSCSI target package on a host.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2017 John Florian


class iscsi::target::package (
        Variant[Boolean, String[1]] $ensure,
        Array[String[1], 1]         $names,
    ) {

    include '::iscsi::target::service'

    package { $names:
        ensure => installed,
        notify => Class['::iscsi::target::service'],
    }

    file { '/etc/tgt/targets.conf':
        owner     => 'root',
        group     => 'root',
        mode      => '0640',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        before    => Class['::iscsi::target::service'],
        notify    => Class['::iscsi::target::service'],
        subscribe => Package[$names],
        content   => template('iscsi/target-defaults.conf.erb'),
        show_diff => false,
    }

}
