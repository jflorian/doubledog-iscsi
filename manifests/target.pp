# == Define: iscsi::target
#
# Manages an iSCSI target.
#
# === Parameters
#
# [*namevar*]
#   An arbitrary identifier for the target instance unless the "iqn" parameter
#   is not set in which case this must provide the value normally set with the
#   "iqn" parameter.
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*iqn*]
#   The iSCSI Qualified Name.  See RFC 3720/3721 for more details.  Briefly,
#   the fields are:
#       - literal "iqn" (iSCSI Qualified Name)
#       - date (yyyy-mm) that the naming authority took ownership of the
#       domain
#       - reversed domain name of the authority (e.g., com.example)
#       - optional ":" prefixing a storage target name specified by the naming
#       authority.
#
# [*backing*]
#   The backing file or block device for the LUN instance.
#
# [*ipaddress*]
#   Initiators must have this IP address to be able to connect.
#
# [*user*]
#   The user name the initiator must use for authentication to connect.
#
# [*password*]
#   The password the initiator must use for authentication to connect.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015 John Florian


define iscsi::target (
        $backing,
        $password,
        $user,
        $ipaddress,
        $iqn=undef,
        $ensure='present',
    ) {

    include '::iscsi::target::service'

    if $iqn {
        $_iqn = $iqn
    } else {
        $_iqn = $name
    }

    file { '/etc/tgt/targets.conf':
        ensure    => $ensure,
        owner     => 'root',
        group     => 'root',
        mode      => '0600',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        before    => Service[$::iscsi::params::target_services],
        notify    => Service[$::iscsi::params::target_services],
        subscribe => Package[$::iscsi::params::target_packages],
        content   => template('iscsi/targets.conf.erb'),
    }

}
