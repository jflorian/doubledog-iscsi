# iscsi

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with iscsi](#setup)
    * [What iscsi affects](#what-iscsi-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with iscsi](#beginning-with-iscsi)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Presently this module allows you to manage iSCSI targets using
scsi-target-utils and iSCSI initiators using iscsi-initiator-utils.  It has
been developed against Fedora 21 using Puppet-3.6.

## Module Description

Using the iscsi::target definition from this module you can quickly provision
an iSCSI target on your network.  This is useful if you have some storage, be
it a file or some block-device that you want to make available over a network.
Any iSCSI initiator would connect to this target and at that end you have what
appears to be a regular SCSI storage device.

Using the iscsi::initiator definition from this module you can quickly attach
to any iSCSI target on your network.  Once attached, that target will appear
as a local block storage device.

It is not necessary for both the initiator and target to be managed by this
module, but that was the development model so other situations may require
enhancing this module for the best possible support.

This module will install the necessary packages, manage configuration files,
and manage the various services related to initiators and/or targets.

## Setup

### What iscsi Affects

#### For iSCSI Initiators

* Installation of the iscsi-initiator-utils package.
* Management of iscsid.conf.
* Management of the iscsid daemon.
* Target discovery and login.

#### For iSCSI Targets

* Installation of the scsi-target-utils package.
* Management of targets.conf.
* Management of the tgtd daemon.
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

Any declaration of an iscsi::target automatically includes
Class[iscsi::target::service] which is responsible for installing the
appropriate package, managing the firewall and appropriate service.

Simarly, any declaration of an iscsi::initiator automatically includes
Class[iscsi::initiator::service] which is responsible for installing the
appropriate package and service.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module
so people know what the module is touching on their system but don't need to
mess with things. (We are working on automating this section!)

## Limitations

Tested on Fedora 21, but likely to work on any Red Hat variant.  See
manifest/params.pp for the most likely obstructions.

## Development

Contributions are welcome.  All code should generally be compliant with
puppet-lint.
