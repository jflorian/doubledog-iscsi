# == Class: iscsi::target::service
#
# Manages the iSCSI target service on a host.
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


class iscsi::target::service (
        Boolean                 $enable,
        Ddolib::Service::Ensure $ensure,
        Boolean                 $manage_firewall,
        Array[String[1], 1]     $names,
    ) {

    include 'iscsi::target::package'

    if $manage_firewall {
        firewall { '500 accept iSCSI target packets':
            dport  => '3260',
            proto  => 'tcp',
            state  => 'NEW',
            action => 'accept',
        }
    }

    service { $names:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}
