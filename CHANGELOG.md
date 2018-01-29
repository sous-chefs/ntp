# ntp Cookbook CHANGELOG

This file is used to list changes made in each version of the ntp cookbook.

## 3.5.6 (2018-01-28)

- Add /var/log/ntpstats/protostats to Apparmor config

## 3.5.5 (2018-01-28)

- Update leap second file. Now expires Dec 2018

## 3.5.4 (2017-11-27)

- Update ntp.leapseconds (expires: 1 Dec 2017 → 28 June 2018)

## 3.5.3 (2017-11-27)

- Fix failing non-interactive install on Solaris10

## 3.5.2 (2017-08-16)

- Fix apprarmor denied for sock_type=dgram in ubuntu dists.

## 3.5.1 (2017-06-28)

- Use the latest NTP release on windows to resolve several bugs
- Fix Amazon Linux support on Chef 13
- Allow windows to sync to the hardware clock when not virtualized since Ohai has provided Windows with virtualization data for a while now
- Update inspec tests to pass on Windows
- Update Chefspecs for the latest platforms

## 3.5.0 (2017-06-27)

- Change RHEL platforms to use the driftfile location RHEL ships out of the box
- Add support for ntp `pool` configuration option
- Fix installation and config on Solaris 10 & 11.
- Set default service name on SLES 11.x
- Fix MacOS X default attributes and OSX chefspec.

## 3.4.0 (2017-05-06)

- Ensure metadata compatibility with older Chef 12 releases
- Testing updates for Chef 13
- Test with Delivery local mode instead of a Rakefile
- Use a SPDX standard license string
- Remove xcp as a platform in the metadata
- Added requestkey attribute

## 3.3.1 (2016-12-21)

- Fix resource cloning warning in recipe[default]

## 3.3.0 (2016-12-16)

- Add Mac OS X client config support

## 3.2.1 (2016-11-23)

- Update leap seconds file to version 3676924800

## 3.2.0 (2016-09-28)

- Remove support for Arch
- Remove legacy apparmor config that wasn't used
- Don't install ntpdate (and uninstall it) on Ubuntu 16.04+
- Expand specs and avoid deprecation warnings

## 3.1.0 (2016-09-16)

- Require Chef 12.1 not 12.0
- Remove the dependency on the Windows cookbook

## 3.0.0 (2016-09-07)

- Require Chef 12+

## 2.0.3 (2016-08-31)

- Remove minitest tests from the undo recipe

## 2.0.2 (2016-08-30)

- Replace node.set with node.normal to avoid deprecation notices

## 2.0.1 (2016-08-29)

- Update the leap seconds file
- Remove node name from configs
- Switch to cookstyle and use the Rakefile directly for testing in Travis CI
- Update platforms we test on
- Fix failing Chefspecs and avoid deprecation warnings during spec runs

## v2.0.0 (2016-05-18)

- Remove the undo recipe. This functionality is better suited for a custom cookbook that matches the needs of individual organizations
- Removed the installation of the visual studio 2008 runtime that was only necessary for Windows 2003.
- Fixed the forced clock syncing on FreeBSD hosts

## v1.11.1 (2016-05-12)

- Ownership of this cookbook has been transferred back to Chef Software.

## v1.11.0 (2016-03-29)

- When force setting the clock run ntp as the ntp user to ensure we don't set file ownership to root
- Added optional support for orphan mode
- Require windows cookbook 1.38.0 to resolve several issues with the older cookbook versions
- Add support for using keys

## v1.10.1 (2016-02-04)

- Update the Readme to include openSUSE and Arch Linux
- Guard the timeout set in the service to prevent failures on old chef releases

## v1.10.0 (2016-02-04)

- Fixed compatibility with FreeBSD hosts by skipping the sync with the hardware clock and using the proper path to the "true" command
- Fixed compatibility with Windows by extending the service start timeout, introducing retries, and excluding Windows from the hardware sync logic
- Changed the default array of packages to install from ntp and ntpdate to just ntp. ntpdate is used on Debian and modern RHEL/Fedora hosts only. This gives us out of the box support for Arch and Suse
- Ensure that Fedora systems also install ntpdate
- Updated test dependencies to the latest
- Updated test documentation to point to the official Chef testing documentation
- Expanded the Test Kitchen config with better support for FreeBSD/Fedora and new Windows boxes

## v1.9.2 (2016-02-04)

- **PR [#121]** - Remove nomodify config from loopback

## v1.9.1 (2016-01-07)

- **PR [#132]** - Update ntp.leapseconds

## v1.9.0 (2015-12-16)

- **PR [#111]** - Fix duplication of localhost listen directive in template
- **PR [#127]** - Set `var_owner` on FreeBSD to root instead of default ntp
- **PR [#117]** - Document node['ntp']['ignore']
- **PR [#118]** - Add attributes to support pld-linux
- **PR [#120]** - Fix links to Github PRs in the Changelog
- **PR [#124]** - Additional fix for apparmor issue gmiranda23#103
- Depend on windows cookbook instead of suggesting. Suggests doesn't actually do anything
- Fix / expand apparmor specs to pass and test the auto apparmor config logic
- Enable Travis CI and update the travis.yml file to run full integration tests with Kitchen Docker so we test all PRs on Ubuntu 12.04/14.04 and CentOS 6.7 / 7.1
- Reformat all markdown files
- Update all references to Opscode to be Chef Software.
- Update copyright dates and contact e-mails
- Expanded platforms in the Test Kitchen config
- Added new supermarket issues_url and source_url metadata
- Update the Berkfile API url and removed version pins on the testing cookbooks
- Remove yum from the Berksfile as it isn't actually used
- Use the standard Chef testing Rakefile
- Remove the attribute documentation from the metadata as it is quickly out of sync
- Resolve rubocop warnings and include the standard Chef rubocop.yml file
- Update development deps in the Gemfile to the latest releases
- Remove the outdated contributing.md doc from the Opscode days

## v1.8.6 (2015-05-14)

- **PR [#102](102)** - Update leapseconds file to 3660249600 (through C49)
- Gemfile parity with ChefDK 0.5.1
- .kitchen.yml platform updates to current bento boxes

## v1.8.4 (2015-04-17)

- **PR [#101]** - add logfile attribute

## v1.8.2 (2015-04-15)

- **PR [#100]** - Sort peers & servers for consistency

## v1.8.0 (2015-04-13)

- Chefspec 4.0 updates
- Rubocop updates
- **PR [#85]** - Update leapseconds for June 2015 leapsecond
- **PR [#70]** - Allow setting tinker options in attributes
- **PR [#84]** - Add attributes for tinker option customization
- **PR [#88]** - Attribute sets noquery for localhost lines
- **PR [#89]** - ntp.leapseconds notifies ntp service with delayed restart
- **PR [#91]** - Allow ntp.conf update to restart immediate
- **PR [#95]** - Add preferred ntp server support
- **PR [#96]** - Add restrict default attribute
- **PR [#72]** - Move high stratum real CMOs to an attribute
- **PR [#98]** - Bump test-kitchen gem version
- **PR [#99]** - Lazy attribute for leapfile_enabled

## v1.7.0 (2014-12-10)

- Added CentOS 7 support for test-kitchen
- **PR [#37]** - Check that apparmor exists before enabling service
- **PR [#45]** - Statistics logging switch (not available for Windows)
- **PR [#57]** - Move include statement on helper outside 'windows?' check
- **PR [#71]** - Ability to listen more than one interface
- **PR [#73]** - Fix appamor configuration for Ubuntu
- **PR [#74]** - Remove is_server from example
- **PR [#75]** - Add more settings for server and peer declarations
- **PR [#83]** - Fix apparmor spec tests

## v1.6.8 (2014-12-04)

- **PR [#81]** - Update to berkshelf3

## v1.6.6 (2014-12-02)

- **PR [#76]** - Overhauled Testing
- **PR [#68]** - Updated Leapseconds
- **PR [#51]** - Berksfile source deprecation

## v1.6.5 (2014-09-25)

- Ensure that ntp version is captured

## v1.6.4 (2014-07-02)

- Leapseconds File Expired, update to 3626380800
- **[COOK-3887](https://tickets.opscode.com/browse/COOK-3887)** - Trivial changes to achieve Gentoo support
- **[COOK-1876](https://tickets.opscode.com/browse/COOK-1876)** - ntp leapfile assumes ntpd >= 4.2.6 syntax

## v1.6.2 (2014-03-19)

- [COOK-4162] - change "No NTP servers specified" message to :debug

## v1.6.0 (2014-02-21)

### Improvement

- **[COOK-4346](https://tickets.opscode.com/browse/COOK-4346)** - Solaris 11 support for ntp
- **[COOK-4339](https://tickets.opscode.com/browse/COOK-4339)** - Disable Monitoring by Default
- **[COOK-3604](https://tickets.opscode.com/browse/COOK-3604)** - Enable listening on specific interfaces

### Bug

- **[COOK-4106](https://tickets.opscode.com/browse/COOK-4106)** - Check for default content in ntp.conf
- **[COOK-4087](https://tickets.opscode.com/browse/COOK-4087)** - quote option in readme
- **[COOK-3797](https://tickets.opscode.com/browse/COOK-3797)** - Cookbook fails to upload due to 1.9.x syntax
- **[COOK-3023](https://tickets.opscode.com/browse/COOK-3023)** - NTP leapseconds file denied by Ubuntu apparmor profile

## v1.5.4 (2013-12-29)

[COOK-4007]- update to 3612902400

## v1.5.2

### Bug

- **[COOK-3797](https://tickets.opscode.com/browse/COOK-3797)** - Add /spec to Chefignore

## v1.5.0

### Improvement

- **[COOK-3651](https://tickets.opscode.com/browse/COOK-3651)** - Refactor and clean up
- **[COOK-3630](https://tickets.opscode.com/browse/COOK-3630)** - Switch NTP cookbook linting from Tailor to Rubocop
- **[COOK-3273](https://tickets.opscode.com/browse/COOK-3273)** - Add tests

### New Feature

- **[COOK-3636](https://tickets.opscode.com/browse/COOK-3636)** - Allow ntp cookbook to update clock to ntp servers

### Bug

- **[COOK-3410](https://tickets.opscode.com/browse/COOK-3410)** - Remove redundant ntpdate/disable recipes
- **[COOK-1170](https://tickets.opscode.com/browse/COOK-1170)** - Allow redefining NTP servers in a role

## v1.4.0

### Improvement

- **[COOK-3365](https://tickets.opscode.com/browse/COOK-3365)** - Update ntp leapseconds file to version 3597177600
- **[COOK-1674](https://tickets.opscode.com/browse/COOK-1674)** - Add Windows support

## v1.3.2

- [COOK-2024] - update leapfile for IERS Bulletin C

## v1.3.0

- [COOK-1404] - add leapfile for handling leap seconds

## v1.2.0

- [COOK-1184] - Add recipe to disable NTP completely
- [COOK-1298] - Refactor into a reference cookbook for testing

## v1.1.8

- [COOK-1158] - RHEL family >= 6 has ntpdate package

## v1.1.6

- Related to changes in COOK-1124, fix group for freebsd and else

## v1.1.4

- [COOK-1124] - parameterised driftfile and statsdir to be configurable by platform

## v1.1.2

- [COOK-952] - freebsd support
- [COOK-949] - check for any virtual system not just vmware

## v1.1.0

- Fixes COOK-376 (use LAN peers, iburst option, LAN restriction attribute)

## v1.0.1

- Support scientific linux
- Use service name attribute in resource (fixes EL derivatives)
