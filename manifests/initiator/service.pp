#
# == Class: iscsi::initiator::service
#
# Manages the iSCSI initiator service on a host.
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


class iscsi::initiator::service (
        Boolean                 $enable,
        Ddolib::Service::Ensure $ensure,
        Optional[String[1]]     $initiator_name,
        Array[String[1], 1]     $names,
    ) {

    include 'iscsi::initiator::package'

    if $initiator_name {
        file { '/etc/iscsi/initiatorname.iscsi':
            content => "InitiatorName=${initiator_name}\n",
            notify  => Service[$names],
            require => Class['iscsi::initiator::package'],
        }
    }

    service { $names:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}
