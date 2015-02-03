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
scsi-target-utils.  Additional support is coming soon for initiators as well.
It has been developed against Fedora 21 using Puppet-3.6.

## Module Description

Using the iscsi::target definition from this module you can quickly provision
an iSCSI target on your network.  This is useful if you have some storage, be
it a file or some block-device that you want to make available over a network.
An iSCSI initiator would connect to this target and at that end you have what
appears to be a regular SCSI storage device.

This module will install the necessary packages, manage target configuration
and manage the target daemon.

## Setup

### What iscsi affects

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

## Usage

Any declaration of an iscsi::target automatically includes
Class[iscsi::target::service] which is responsible for installing the package,
managing the firewall and service.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module
so people know what the module is touching on their system but don't need to
mess with things. (We are working on automating this section!)

## Limitations

Tested on Fedora 21, but likely to work on any Red Hat variant.

## Development

Contributions are welcome.  All code should generally be compliant with
puppet-lint.
