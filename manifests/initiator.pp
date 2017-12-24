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
#   Instance is to be 'present' (default) or 'absent'.  Alternatively,
#   a Boolean value may also be used with true equivalent to 'present' and
#   false equivalent to 'absent'.
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
# Copyright 2015-2017 John Florian


define iscsi::initiator (
        String[1] $password,
        String[1] $user,
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        Integer[0, 65535] $port=3260,
        String[1] $target=$title,
    ) {

    include '::iscsi::initiator::package'
    include '::iscsi::initiator::service'

    file { '/etc/iscsi/iscsid.conf':
        ensure    => $ensure,
        owner     => 'root',
        group     => 'root',
        mode      => '0600',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        before    => Class['::iscsi::initiator::service'],
        notify    => Class['::iscsi::initiator::service'],
        subscribe => Class['::iscsi::initiator::package'],
        content   => template('iscsi/iscsid.conf.erb'),
        show_diff => false,
    }

    exec { "discover iSCSI targets at '${target}:${port}'":
        command => "iscsiadm -m discovery -t sendtargets -p ${target}:${port} -l",
        unless  => "iscsiadm -m node -p '${target}:${port}'",
        require => Class['::iscsi::initiator::package'],
        notify  => Class['::iscsi::initiator::service'],
    }

}
