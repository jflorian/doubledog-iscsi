# == Class: iscsi::target::package
#
# Manages the iSCSI target package on a host.
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


class iscsi::target::package (
        Variant[Boolean, String[1]] $ensure = 'installed',
    ) inherits ::iscsi::params {

    package { $::iscsi::params::target_packages:
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
        subscribe => Package[$::iscsi::params::target_packages],
        content   => template('iscsi/target-defaults.conf.erb'),
        show_diff => false,
    }

}
