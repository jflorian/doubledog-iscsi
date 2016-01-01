# == Class: iscsi::params
#
# Parameters for the iscsi puppet module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2015-2016 John Florian


class iscsi::params {

    case $::operatingsystem {

        'Fedora': {

            $initiator_packages = 'iscsi-initiator-utils'
            $initiator_services = 'iscsid'

            $target_packages = 'scsi-target-utils'
            $target_services = 'tgtd'

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
