# iscsi

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with iscsi](#setup)
    * [What iscsi affects](#what-iscsi-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with iscsi](#beginning-with-iscsi)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined types](#defined-types)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Presently this module allows you to manage iSCSI targets using
scsi-target-utils and iSCSI initiators using iscsi-initiator-utils.  It was
first developed against Fedora 21 using Puppet-3.6.  It's since been used on Fedora
23 through Fedora 27 and also on CentOS 7.

Using the [iscsi::target](#iscsitarget-defined-type) definition from this
module you can quickly provision an iSCSI target on your network.  This is
useful if you have some storage, be it a file or some block-device that you
want to make available over a network.  Any iSCSI initiator would connect to
this target and at that end you have what appears to be a regular SCSI storage
device.

Using the [iscsi::initiator](#iscsiinitiator-defined-type) definition from this
module you can quickly attach to any iSCSI target on your network.  Once
attached, that target will appear as a local block storage device.

It is not necessary for both the initiator and target to be managed by this
module, but that was the development model so other situations may require
enhancing this module for the best possible support.

This module will install the necessary packages, manage configuration files,
and manage the various services related to initiators and/or targets.

## Setup

### What iscsi Affects

#### For iSCSI Initiators

* Installation of the `iscsi-initiator-utils` package.
* Management of `iscsid.conf`.
* Management of the `iscsid` daemon.
* Target discovery and login.

#### For iSCSI Targets

* Installation of the `scsi-target-utils` package.
* Management of `targets.conf`.
* Management of the `tgtd` daemon.
* Optional management of relevant firewall rules.

### Setup Requirements

This module, by default, will manage firewall rules using PuppetLab's firewall
module (available from the Puppet Module Forge).  This functionality can
easily be disabled via parameters.

### Beginning with iscsi

#### Provisioning an iSCSI Target ####

A very simple target setup looks like:

    iscsi::target { 'iqn.2015-01.com.example:storage.backups':
        backing   => '/dev/sdb1',
        ipaddress => '192.168.1.123',
        user      => 'backupUser',
        password  => 'SecretSquirrelSauce',
    }

This examples uses /dev/sdb1 as the backing-store for the iSCSI target and
configures the ACL to only allow an initiator with IP address 192.168.1.123 to
connect.  Furthermore that initiator must provide the given user name and
password for the CHAP initiator authentication.

#### Provisioning an iSCSI Initiator ####

This example could be applied on a host with IP address 192.168.1.123 to
connect to the example target shown above, assuming it was at IP address
192.168.1.234:

    iscsi::initiator { '192.168.1.246':
        user     => 'backupUser',
        password => 'SecretSquirrelSauce',
    }

If you were to look at /proc/partitions before and after applying this, you
should see that a new block device appears.  You could then use that new
device like any other just as if was locally attached.

## Usage

Any declaration of an [iscsi::target](#iscsitarget-defined-type) automatically
includes the [iscsi::target::package](#iscsitargetpackage-class) and
[iscsi::target::service](#iscsitargetservice-class) classes which are
responsible for installing the appropriate package(s), managing the firewall
and appropriate service(s) respectively.

Similarly, any declaration of an
[iscsi::initiator](#iscsiinitiator-defined-type) automatically includes
[iscsi::initiator::package](#iscsiinitiatorpackage-class) and
[iscsi::initiator::service](#iscsiinitiatorservice-class) which are responsible
for installing/managing their appropriate package(s) and service(s).

## Reference

**Classes:**

* [iscsi::initiator::package](#iscsiinitiatorpackage-class)
* [iscsi::initiator::service](#iscsiinitiatorservice-class)
* [iscsi::target::package](#iscsitargetpackage-class)
* [iscsi::target::service](#iscsitargetservice-class)

**Defined types:**

* [iscsi::initiator](#iscsiinitiator-defined-type)
* [iscsi::target](#iscsitarget-defined-type)


### Classes

#### iscsi::initiator::package class

This class manages the iSCSI initiator package(s) on a host.

##### `ensure`
The desired package state.  This can be `installed` (default), `absent`, or any
other value appropriate to the Package resource type.

##### `names`
An array of package names needed for the initiator installation.  The default
should be correct for supported platforms.


#### iscsi::initiator::service class

This class manages the iSCSI initiator service(s) on a host.

##### `enable`
Instance is to be started at boot.  Either `true` (default) or `false`.

##### `ensure`
Instance is to be `running` (default) or `stopped`.  Alternatively, a Boolean
value may also be used with `true` equivalent to `running` and `false`
equivalent to `stopped`.

##### `names`
An array of service names needed for the initiator.  The default should be
correct for supported platforms.


#### iscsi::target::package class

This class manages the iSCSI target package(s) on a host.

##### `ensure`
The desired package state.  This can be `installed` (default), `absent`, or any
other value appropriate to the Package resource type.

##### `names`
An array of package names needed for the target installation.  The default
should be correct for supported platforms.


#### iscsi::target::service class

This class manages the iSCSI target service(s) on a host.

##### `enable`
Instance is to be started at boot.  Either `true` (default) or `false`.

##### `ensure`
Instance is to be `running` (default) or `stopped`.  Alternatively, a Boolean
value may also be used with `true` equivalent to `running` and `false`
equivalent to `stopped`.

##### `manage_firewall`
A Boolean value indicating whether to manage the firewall or not.  Defaults to
`true`.

##### `names`
An array of service names needed for the target.  The default should be
correct for supported platforms.


### Defined types

#### iscsi::initiator defined type

This defined type manages an iSCSI initiator using the "send targets" discovery
method.

##### `namevar`
An arbitrary identifier for the initiator instance unless the `target`
parameter is not set in which case this must provide the value normally set
with the `target` parameter.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean
value may also be used with `true` equivalent to `present` and `false`
equivalent to `absent`.

##### `password`
The password the target requires for connection authentication.

##### `port`
The TCP port on the target to which is to be connected.  Defaults to 3260.

##### `target`
Hostname or IP address of the target that is to be connected.

This may be used in place of `namevar` if it's beneficial to give namevar an
arbitrary value.

##### `user`
The user name the target requires for connection authentication.


#### iscsi::target defined type

This defined type manages an iSCSI target.

##### `namevar`
An arbitrary identifier for the target instance unless the `iqn` parameter is
not set in which case this must provide the value normally set with the `iqn`
parameter.

##### `backing`
The backing file or block device for the LUN instance.

##### `password`
The password the initiator must use for authentication to connect.

##### `user`
The user name the initiator must use for authentication to connect.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean
value may also be used with `true` equivalent to `present` and `false`
equivalent to `absent`.

##### `ipaddress`
Allows connections only from the specified IP address.  Defaults to `undef`,
which allows connections from any IP address.

##### `iqn`
The iSCSI Qualified Name.  See RFC 3720/3721 for more details.  Briefly, the
fields are:
* literal string of `iqn` (iSCSI Qualified Name)
* date (yyyy-mm) that the naming authority took ownership of the domain
* reversed domain name of the authority (e.g., `com.example`)
* optional `:` prefixing a storage target name specified by the naming authority

This may be used in place of `namevar` if it's beneficial to give namevar an
arbitrary value.


## Limitations

Tested on Fedora 27 and CentOS 7, but likely to work on any Red Hat variant.
See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

This should be compatible with Puppet 3.x and is being used with Puppet 4.x as
well.

## Development

Contributions are welcome via pull requests.  All code should generally be
compliant with puppet-lint.
