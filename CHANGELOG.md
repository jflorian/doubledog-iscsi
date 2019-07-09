<!--
This file is part of the doubledog-iscsi Puppet module.
Copyright 2018-2019 John Florian
SPDX-License-Identifier: GPL-3.0-or-later

Template

## [VERSION] WIP
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

-->

# Change log

All notable changes to this project (since v1.1.0) will be documented in this file.  The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [1.5.0] WIP
### Added
- `Iscsi::Discovery` data type
### Changed
### Deprecated
### Removed
### Fixed
- [target discovery recurs with every run](https://github.com/jflorian/doubledog-iscsi/issues/8) on Fedora 30 with `iscsi-initiator-utils-6.2.0.876-8.gitf3c8e90.fc30.x86_64`
### Security

## [1.4.0] 2019-06-06
### Added
- Puppet 6 compatibility
- `iscsi::initiator::service::initiator_name` parameter
### Changed
- `validate_absolute_path()` function to `Stdlib::Absolutepath` data type

## [1.3.0] 2019-05-02
### Added
- Fedora 30 support
### Changed
- dependency on `doubledog/ddolib` now expects 1 >= version < 2
### Deprecated
- Absolute namespace references have been eliminated since modern Puppet versions no longer require this.
### Removed
- Fedora 27 support

## [1.2.0] 2018-12-15
### Added
- Fedora 28/29 support
### Changed
- puppetlabs-stdlib dependency now allows version 5
- use Hiera 5
### Removed
- Fedora 25/26 support

## [1.1.0 and prior] 2018-12-15

This and prior releases predate this project's keeping of a formal CHANGELOG.  If you are truly curious, see the Git history.
