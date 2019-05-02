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
# This file is part of the doubledog-iscsi Puppet module.
# Copyright 2017-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class iscsi::initiator::package (
        Variant[Boolean, String[1]] $ensure,
        Array[String[1], 1]         $names,
    ) {

    package { $names:
        ensure => $ensure,
        notify => Class['iscsi::initiator::service'],
    }

}
