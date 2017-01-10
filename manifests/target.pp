# == Define: iscsi::target
#
# Manages an iSCSI target.
#
# === Parameters
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the target instance unless the "iqn" parameter
#   is not set in which case this must provide the value normally set with the
#   "iqn" parameter.
#
# [*backing*]
#   The backing file or block device for the LUN instance.
#
# [*password*]
#   The password the initiator must use for authentication to connect.
#
# [*user*]
#   The user name the initiator must use for authentication to connect.
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.  Alternatively,
#   a Boolean value may also be used with true equivalent to 'present' and
#   false equivalent to 'absent'.
#
# [*ipaddress*]
#   Allows connections only from the specified IP address.  Defaults to
#   allowing connections from any IP address.
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


define iscsi::target (
        String[1] $backing,
        String[1] $password,
        String[1] $user,
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        Optional[String[1]] $ipaddress=undef,
        String[1] $iqn=$title,
    ) {

    validate_absolute_path($backing)

    include '::iscsi::target::service'

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
        show_diff => false,
    }

}
