# == Class: iscsi::target::service
#
# Manages the iSCSI target service on a host.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*enable*]
#   Instance is to be started at boot.  Either true (default) or false.
#
# [*ensure*]
#   Instance is to be 'running' (default) or 'stopped'.  Alternatively,
#   a Boolean value may also be used with true equivalent to 'running' and
#   false equivalent to 'stopped'.
#
# [*manage_firewall*]
#   Whether to manage the firewall or not.  Defaults to true.
#
# [*names*]
#   An array of service names needed for the target.  The default should be
#   correct for supported platforms.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


class iscsi::target::service (
        Boolean                                         $enable,
        Variant[Boolean, Enum['running', 'stopped']]    $ensure,
        Boolean                                         $manage_firewall,
        Array[String[1], 1]                             $names,
    ) {

    include '::iscsi::target::package'

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
