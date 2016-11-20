# == Define: iscsi::initiator
#
# Manages an iSCSI initiator using the "send targets" discovery method.
#
# === Parameters
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the initiator instance unless the "target"
#   parameter is not set in which case this must provide the value normally
#   set with the "target" parameter.
#
# [*password*]
#   The password the target requires for connection authentication.
#
# [*user*]
#   The user name the target requires for connection authentication.
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*port*]
#   The TCP port on the target to which is to be connected.  Defaults to 3260.
#
# [*target*]
#   Hostname or IP address of the target that is to be connected.
#
#   This may be used in place of "namevar" if it's beneficial to give namevar
#   an arbitrary value.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2016 John Florian


define iscsi::initiator (
        $password,
        $user,
        $ensure='present',
        $port=3260,
        $target=$title,
    ) {

    include '::iscsi::initiator::service'

    file { '/etc/iscsi/iscsid.conf':
        ensure    => $ensure,
        owner     => 'root',
        group     => 'root',
        mode      => '0600',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        before    => Service[$::iscsi::params::initiator_services],
        notify    => Service[$::iscsi::params::initiator_services],
        subscribe => Package[$::iscsi::params::initiator_packages],
        content   => template('iscsi/iscsid.conf.erb'),
        show_diff => false,
    }

    exec { "discover iSCSI targets at '${target}:${port}'":
        command => "iscsiadm -m discovery -t sendtargets -p ${target}:${port} -l",
        unless  => "iscsiadm -m node -p '${target}:${port}'",
        require => Package[$::iscsi::params::initiator_packages],
        notify  => Service[$::iscsi::params::initiator_services],
    }

}
