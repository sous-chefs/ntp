# NTP Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/ntp.svg?branch=master)](http://travis-ci.org/chef-cookbooks/ntp) [![Cookbook Version](https://img.shields.io/cookbook/v/ntp.svg)](https://supermarket.chef.io/cookbooks/ntp)

Installs and configures ntp. On Windows systems it uses the Meinberg port of the standard NTPd client to Windows.

## Requirements

### Platforms

- Debian-family Linux Distributions
- RedHat-family Linux Distributions
- Fedora
- Gentoo Linux
- openSUSE
- FreeBSD
- Windows 2008 R2+
- Mac OS X 10.11+

### Chef

- Chef 12.1+

### Cookbooks

- none

## Attributes

### Recommended tunables

- `ntp['servers']` - (applies to NTP Servers and Clients)

  - Array, should be a list of upstream NTP servers that will be considered authoritative by the local NTP daemon. The local NTP daemon will act as a client, adjusting local time to match time data retrieved from the upstream NTP servers.

  The NTP protocol works best with at least 4 servers. The ntp daemon will disregard any server after the 10th listed, but will continue monitoring all listed servers. For more information, see [Upstream Server Time Quantity](http://support.ntp.org/bin/view/Support/SelectingOffsiteNTPServers#Section_5.3.3.) at [support.ntp.org](http://support.ntp.org).

- `ntp['pools']` - (applies to NTP Servers and Clients)

  - Array, should be a list of upstream NTP pools that will be considered authoritative by the local NTP daemon. The local NTP daemon will act as a client, adjusting local time to match time data retrieved from each of the servers in the upstream pool.

  See this [Release Announcement](http://lists.ntp.org/pipermail/questions/2010-April/026304.html) for discussion about tuning this option.

- `ntp['peers']` - (applies to NTP Servers ONLY)

  - Array, should be a list of local NTP peers. For more information, see [Designing Your NTP Network](http://support.ntp.org/bin/view/Support/DesigningYourNTPNetwork) at [support.ntp.org](http://support.ntp.org).

- `ntp['restrictions']` - (applies to NTP Servers only)

  - Array, should be a list of restrict lines to define access to NTP clients on your LAN.

- `ntp['sync_clock']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to false. Forces the ntp daemon to be halted, an ntp -q command to be issued, and the ntp daemon to be restarted again on every Chef-client run. Will have no effect if drift is over 1000 seconds.

- `ntp['sync_hw_clock']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to false. On *nix-based systems, forces the 'hwclock --systohc' command to be issued on every Chef-client run. This will sync the hardware clock to the system clock.
  - Not available on Windows.

- `ntp['restrict_default']`

  - String. Defaults to 'kod notrap nomodify nopeer noquery'. Set to 'ignore' to [further lock down access](http://support.ntp.org/bin/view/Support/AccessRestrictions#Section_6.5.1.1.2.).

- `ntp["listen_network"]` / `ntp["listen"]`

  - String, optional attribute. Default is for NTP to listen on all addresses.
  - `ntp["listen_network"]` should be set to 'primary' to listen on the node's primary IP address as determined by ohai, or set to a CIDR (eg: '192.168.4.0/24') to listen on the last node address on that CIDR.
  - `ntp["listen"]` can be set to a specific address (eg: '192.168.4.10') instead of `ntp["listen_network"]` to force listening on a specific address.
  - If both `ntp["listen"]` and `ntp["listen_network"]` are set then `ntp["listen"]` will always win.

- `ntp["ignore"]`

  - Array, interface names to ignore from listening. Can be used to disable listening wildcard interfaces (eg: ['wildcard', '::1']), can be combined with `ntp["listen"]`

- `ntp["statistics"]`

  - Boolean. Default to true. Enable/disable statistics data logging into `ntp['statsdir']`.
  - Not available on Windows.

- `ntp['conf_restart_immediate']`

  - Boolean. Defaults to false. Restarts NTP service immediately after a config update if true. Otherwise it is a delayed restart.

- `ntp['peer']['disable_tinker_panic_on_virtualization_guest']` (applies to virtualized hosts only)

  - Boolean. Defaults to true. Sets tinker panic to 0\. NTP default it 1000\. (See <http://www.vmware.com/vmtn/resources/238> p. 23 for explanation on disabling panic) (Note: this overrides `ntp['tinker']['panic']` attribute)

- `ntp['peer']['use_iburst']` (applies to NTP Servers ONLY)

  - Boolean. Defaults to true. Enables iburst in peer declaration.

- `ntp['peer']['use_burst']` (applies to NTP Servers ONLY)

  - Boolean. Defaults to false. Enables burst in peer declaration.

- `ntp['peer']['minpoll']` (applies to NTP Servers ONLY)

  - Boolean. Defaults to 6 (ntp default). Specify the minimum poll intervals for NTP messages, in seconds to the power of two.

- `ntp['peer']['maxpoll']` (applies to NTP Servers ONLY)

  - Boolean. Defaults to 10 (ntp default). Specify the maximum poll intervals for NTP messages, in seconds to the power of two.

- `ntp['server']['prefer']` (applies to NTP Servers and Clients)

  - String. Defaults to emtpy string. The server from `ntp['servers']` to prefer getting the time from.

- `ntp['server']['use_iburst']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to true. Enables iburst in server declaration.

- `ntp['server']['use_burst']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to false. Enables burst in server declaration.

- `ntp['server']['minpoll']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to 6 (ntp default). Specify the minimum poll intervals for NTP messages, in seconds to the power of two.

- `ntp['server']['maxpoll']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to 10 (ntp default). Specify the maximum poll intervals for NTP messages, in seconds to the power of two.

- `ntp['tinker']['allan']`

  - Number. Defaults to 1500 (ntp default). Spedifies the Allan intercept, which is a parameter of the PLL/FLL clock discipline algorithm, in seconds.

- `ntp['tinker']['dispersion']`

  - Number. Defaults to 15 (ntp default). Specifies the dispersion increase rate in parts-per-million (PPM).

- `ntp['tinker']['panic']`

  - Number. Defaults to 1000 (ntp default). Spedifies the panic threshold in seconds. If set to zero, the panic sanity check is disabled and a clock offset of any value will be accepted.

- `ntp['tinker']['step']`

  - Number. Defaults to 0.128 (ntp default). Spedifies the step threshold in seconds. If set to zero, step adjustments will never occur. Note: The kernel time discipline is disabled if the step threshold is set to zero or greater than 0.5 s.

- `ntp['tinker']['stepout']`

  - Number. Defaults to 900 (ntp default). Specifies the stepout threshold in seconds. If set to zero, popcorn spikes will not be suppressed.

- `ntp['localhost']['noquery']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to false. Set to true if using ntp < 4.2.8 or any unpatched ntp version to mitigate CVE-2014-9293 / CVE-2014-9294 / CVE-2014-9295

- `ntp['orphan']['enabled']`

  - Boolean, enables orphan mode if set to true

- `ntp['orphan']['stratum']`

  - Number. Defaults to 5, recommended value for stratum is 2 more than the worst-case externally-reachable source of time

### Automatically Set Attributes

These attributes are set based on platform / system information provided by Ohai

- `ntp['packages']`

  - Array, the packages to install
  - Default, ntp for everything, ntpdate depending on platform. Not applicable for Windows nodes.

- `ntp['service']`

  - String, the service to act on
  - Default, ntp, NTP, or ntpd, depending on platform

- `ntp['varlibdir']`

  - String, the path to /var/lib files such as the driftfile.
  - Default, platform-specific location. Not applicable for Windows nodes

- `ntp['driftfile']`

  - String, the path to the frequency file.
  - Default, platform-specific location.

- `ntp['conffile']`

  - String, the path to the ntp configuration file.
  - Default, platform-specific location.

- `ntp['statsdir']`

  - String, the directory path for files created by the statistics facility.
  - Default, platform-specific location. Not applicable for Windows nodes

- `ntp['conf_owner'] and ntp['conf_group']`

  - String, the owner and group of the sysconf directory files, such as /etc/ntp.conf.
  - Default, platform-specific root:root or root:wheel.

- `ntp['var_owner'] and ntp['var_group']`

  - String, the owner and group of the /var/lib directory files, such as /var/lib/ntp.
  - Default, platform-specific ntp:ntp or root:wheel. Not applicable for Windows nodes

- `ntp['leapfile']`

  - String, the path to the ntp leapfile.
  - Default, /etc/ntp.leapseconds.

- `ntp['package_url']`

  - String, the URL to the the Meinberg NTPd client installation package.
  - Default, Meinberg site download URL
  - Windows platform only

- `ntp['vs_runtime_url']`

  - String, the URL to the the Visual Studio C++ 2008 runtime libraries that are required for the Meinberg NTP client.
  - Default, Microsoft site download URL
  - Windows platform only

- `ntp['vs_runtime_productname']`

  - String, the installation name of the Visual Studio C++ Runtimes file.
  - Default, "Microsoft Visual C++ 2008 Redistributable - x86 9.0.21022"
  - Windows platform only

- `ntp['sync_hw_clock']`

  - Boolean, determines if the ntpdate command is issued to sync the hardware clock
  - Default, false
  - Not applicable for Windows nodes

- `ntp['apparmor_enabled']`

  - Boolean, enables configuration of apparmor if set to true
  - Defaults to false and will make no provisions for apparmor.
  - If a platform has apparmor enabled (currently Ubuntu) default will become true.

- `ntp['use_cmos']`

  - Boolean, uses a high stratum undisciplined clock for machines with real CMOS clock.
  - Defaults to true unless a platform appears to be virtualized according to Ohai.

- `ntp['pkg_source']`
  - _Only applicable to Solaris 10_
  - String, device/path to Solaris packages.
  - Defaults to `/var/spool/pkg`

## Usage

### default recipe

Set up the ntp attributes in a role. For example in a base.rb role applied to all nodes:

```ruby
name 'base'
description 'Role applied to all systems'
default_attributes(
  'ntp' => {
    'servers' => ['time0.int.example.org', 'time1.int.example.org']
  }
)
```

Then in an ntpserver.rb role that is applied to NTP servers (e.g., time.int.example.org):

```ruby
name 'ntp_server'
description 'Role applied to the system that should be an NTP server.'
default_attributes(
  'ntp' => {
    'servers'      => ['0.pool.ntp.org', '1.pool.ntp.org'],
    'peers'        => ['time0.int.example.org', 'time1.int.example.org'],
    'restrictions' => ['10.0.0.0 mask 255.0.0.0 nomodify notrap']
  }
)
```

The timeX.int.example.org used in these roles should be the names or IP addresses of internal NTP servers. Then simply add ntp, or `ntp::default` to your run_list to apply the ntp daemon's configuration.

### windows_client recipe

Windows only. Apply on a Windows host to install the Meinberg NTPd client.

### mac_os_x_client recipe

Mac OS X only. Apply on a Mac OS X host to configure NTP.

## License & Authors

- Author:: Joshua Timberman ([joshua@chef.io](mailto:joshua@chef.io))
- Contributor:: Eric G. Wolfe ([wolfe21@marshall.edu](mailto:wolfe21@marshall.edu))
- Contributor:: Fletcher Nichol ([fletcher@nichol.ca](mailto:fletcher@nichol.ca))
- Contributor:: Tim Smith ([tsmith@chef.io](mailto:tsmith@chef.io))
- Contributor:: Charles Johnson ([charles@chef.io](mailto:charles@chef.io))
- Contributor:: Brad Knowles ([bknowles@momentumsi.com](mailto:bknowles@momentumsi.com))

```text
Copyright 2009-2016, Chef Software, Inc.
Copyright 2012, Eric G. Wolfe
Copyright 2012, Fletcher Nichol
Copyright 2012, Webtrends, Inc.
Copyright 2013, Limelight Networks, Inc.
Copyright 2013, Brad Knowles
Copyright 2013, Brad Beam

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
