# == Define: iscsi::target
#
# Manages an iSCSI target.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2017 John Florian


define iscsi::target (
        String[1] $backing,
        String[1] $password,
        String[1] $user,
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        Optional[String[1]] $ipaddress=undef,
        String[1] $iqn=$title,
    ) {

    validate_absolute_path($backing)

    include '::iscsi::target::package'
    include '::iscsi::target::service'

    file { "/etc/tgt/conf.d/${iqn}.conf":
        ensure    => $ensure,
        owner     => 'root',
        group     => 'root',
        mode      => '0600',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        before    => Class['::iscsi::target::service'],
        notify    => Class['::iscsi::target::service'],
        subscribe => Class['::iscsi::target::package'],
        content   => template('iscsi/target.conf.erb'),
        show_diff => false,
    }

}
