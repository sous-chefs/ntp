# NTP Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/ntp.svg)](https://supermarket.chef.io/cookbooks/ntp)
[![CI State](https://github.com/sous-chefs/ntp/workflows/ci/badge.svg)](https://github.com/sous-chefs/ntp/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures ntp. On Windows systems it uses the Meinberg port of the standard NTPd client to Windows.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian-family Linux Distributions
- RedHat-family Linux Distributions 5-7 (8 does not contain NTP client)
- Fedora
- Gentoo Linux
- FreeBSD
- Windows 2008 R2+
- macOS 10.11+

### Chef

- Chef 15.5+

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

  - Boolean. Defaults to false. On \*nix-based systems, forces the 'hwclock --systohc' command to be issued on every Chef-client run. This will sync the hardware clock to the system clock.
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

  - Number. Defaults to 1500 (ntp default). Specifies the Allan intercept, which is a parameter of the PLL/FLL clock discipline algorithm, in seconds.

- `ntp['tinker']['dispersion']`

  - Number. Defaults to 15 (ntp default). Specifies the dispersion increase rate in parts-per-million (PPM).

- `ntp['tinker']['panic']`

  - Number. Defaults to 1000 (ntp default). Specifies the panic threshold in seconds. If set to zero, the panic sanity check is disabled and a clock offset of any value will be accepted.

- `ntp['tinker']['step']`

  - Number. Defaults to 0.128 (ntp default). Specifies the step threshold in seconds. If set to zero, step adjustments will never occur. Note: The kernel time discipline is disabled if the step threshold is set to zero or greater than 0.5 s.

- `ntp['tinker']['stepout']`

  - Number. Defaults to 900 (ntp default). Specifies the stepout threshold in seconds. If set to zero, popcorn spikes will not be suppressed.

- `ntp['localhost']['noquery']` (applies to NTP Servers and Clients)

  - Boolean. Defaults to false. Set to true if using ntp < 4.2.8 or any unpatched ntp version to mitigate CVE-2014-9293 / CVE-2014-9294 / CVE-2014-9295

- ntp['tos']['maxdist']

  - Number. Defaults to 1 (ntp default). Specifies the tos maxdist value in seconds. Where the remote ntp server is a Windows domain controller, this value can be set to 30.

- `ntp['orphan']['enabled']`

  - Boolean, enables orphan mode if set to true

- `ntp['orphan']['stratum']`

  - Number. Defaults to 5, recommended value for stratum is 2 more than the worst-case externally-reachable source of time

- `ntp['dscp']`

  - Number. Default is set to `nil`, This option specifies the Differentiated Services Control Point (DSCP) value, a 6-bit code. The default value is 46, signifying Expedited Forwarding.
  - This is to support Cisco Application Centric Infrastructure (ACI).

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

- `['ntp']['leapfile_managed_by_os']`
  - Boolean. Defaults to false. This uses leapfile provided by the cookbook, when combined with leapfile you can use the leapfile provided by your OS.

- `ntp['leapfile']`

  - String, the path to the ntp leapfile.
  - Default: `/etc/ntp.leapseconds`
  - Debian default: `/usr/share/zoneinfo/leap-seconds.list`,
  - RedHat default: `/usr/share/zoneinfo/leapseconds`

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

- `ntp['pkg_source']`
  - _Only applicable to Solaris 10_
  - String, device/path to Solaris packages.
  - Defaults to `/var/spool/pkg`

- `ntp['leapfile_from_mirror']`
  - Using ntp.leapseconds from http resources. Store `true` with `ntp['leapfile_url']` file location
  - Boolean
  - Defaults to false

- `ntp['leapfile_url']`
  - Remote file location of ntp.leapseconds. Use only with `ntp ['leapfile_from_mirror'] = true`
  - String, URL

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

macOS only. Apply on a macOS host to configure NTP.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
