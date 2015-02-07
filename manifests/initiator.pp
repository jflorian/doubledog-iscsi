# == Define: iscsi::initiator
#
# Manages an iSCSI initiator using the "send targets" discovery method.
#
# === Parameters
#
# [*namevar*]
#   An arbitrary identifier for the initiator instance unless the "target"
#   parameter is not set in which case this must provide the value normally
#   set with the "target" parameter.
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*target*]
#   Hostname or IP address of the target that is to be connected.
#
# [*port*]
#   The TCP port on the target to which is to be connected.  Defaults to 3260.
#
# [*user*]
#   The user name the target requires for connection authentication.
#
# [*password*]
#   The password the target requires for connection authentication.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015 John Florian


define iscsi::initiator (
        $user,
        $password,
        $target=undef,
        $port=3260,
        $ensure='present',
    ) {

    include '::iscsi::initiator::service'

    if $target {
        $_target = $target
    } else {
        $_target = $name
    }

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
    }

    exec { "discover iSCSI targets at '${_target}:${port}'":
        command => "iscsiadm -m discovery -t sendtargets -p ${_target}:${port}",
        unless  => "test -d /var/lib/iscsi/send_targets/${_target},${port}",
        require => Class['::iscsi::initiator::service'],
    }

}
