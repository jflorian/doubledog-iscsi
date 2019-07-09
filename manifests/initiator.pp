#
# == Define: iscsi::initiator
#
# Manages an iSCSI initiator using the "send targets" discovery method.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-iscsi Puppet module.
# Copyright 2015-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define iscsi::initiator (
        Optional[String[1]]     $password,
        Optional[String[1]]     $user,
        Boolean                 $enable_chap = true,
        Ddolib::File::Ensure    $ensure='present',
        Integer[0, 65535]       $port=3260,
        String[1]               $target=$title,
    ) {

    include 'iscsi::initiator::package'
    include 'iscsi::initiator::service'

    if !defined(File['/etc/iscsi/iscsid.conf']) {
        file { '/etc/iscsi/iscsid.conf':
            ensure    => $ensure,
            owner     => 'root',
            group     => 'root',
            mode      => '0600',
            seluser   => 'system_u',
            selrole   => 'object_r',
            seltype   => 'etc_t',
            before    => Class['iscsi::initiator::service'],
            notify    => Class['iscsi::initiator::service'],
            subscribe => Class['iscsi::initiator::package'],
            content   => template('iscsi/iscsid.conf.erb'),
            show_diff => false,
        }
    }

    exec { "discover iSCSI targets at '${target}:${port}'":
        command => "iscsiadm -m discovery -t sendtargets -p ${target}:${port} -l",
        unless  => "iscsiadm -m discoverydb -t sendtargets -p ${target}:${port} -o show",
        require => Class['iscsi::initiator::package'],
        notify  => Class['iscsi::initiator::service'],
    }

}
