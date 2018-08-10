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
# Copyright 2015-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class iscsi::initiator::service (
        Boolean                 $enable,
        Ddolib::Service::Ensure $ensure,
        Array[String[1], 1]     $names,
        String[1]               $initiator_name,
    ) {

    include '::iscsi::initiator::package'

    service { $names:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}
