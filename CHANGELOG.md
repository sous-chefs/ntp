## [COOK-1298]

* Refactor cookbook for simplified data-driven recipe code
* Add test scaffolding
* Add rake tasks for attribute testing and foodcritic
* Deprecate ntp::disable in favor of separate ntp::undo and ntp::ntpdate
* ntp::ntpdate now operates based on boolean "disable" attribute
* Add Travis CI integration
* Update documentation and metadata
* Add reference documentation for cookbook testing

## v1.1.8:

* [COOK-1158] - RHEL family >= 6 has ntpdate package

## v1.1.6:

* Related to changes in COOK-1124, fix group for freebsd and else

## v1.1.4:

* [COOK-1124] - parameterised driftfile and statsdir to be
  configurable by platform

## v1.1.2:

* [COOK-952] - freebsd support
* [COOK-949] - check for any virtual system not just vmware

## v1.1.0:

* Fixes COOK-376 (use LAN peers, iburst option, LAN restriction attribute)

## v1.0.1:

* Support scientific linux
* Use service name attribute in resource (fixes EL derivatives)
