#
# == Type: Iscsi::Discovery
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-iscsi Puppet module.
# Copyright 2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


type Iscsi::Discovery = Enum[
    'sendtargets',
    'slp',
    'isns',
    'fw',
]
