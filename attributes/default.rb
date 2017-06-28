#
# Cookbook:: ntp
# Attributes:: default
#
# Author:: Joshua Timberman (<joshua@chef.io>)
# Author:: Tim Smith (<tsmith@chef.io>)
# Author:: Charles Johnson (<charles@chef.io>)
#
# Copyright:: 2009-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# default attributes for all platforms
default['ntp']['servers'] = [] # The default recipe sets a list of common NTP servers (COOK-1170)
default['ntp']['peers'] = []
default['ntp']['pools'] = []
default['ntp']['restrictions'] = []
default['ntp']['tinker'] = { 'panic' => 0 }

# set `restrict default` for IPv4 and IPv6
default['ntp']['restrict_default'] = 'kod notrap nomodify nopeer noquery'

# internal attributes
default['ntp']['packages'] = %w(ntp)
default['ntp']['service'] = 'ntpd'
default['ntp']['varlibdir'] = '/var/lib/ntp'
default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/ntp.drift"
default['ntp']['logfile'] = nil
default['ntp']['conffile'] = '/etc/ntp.conf'
default['ntp']['statsdir'] = '/var/log/ntpstats/'
default['ntp']['conf_owner'] = 'root'
default['ntp']['conf_group'] = 'root'
default['ntp']['var_owner'] = 'ntp'
default['ntp']['var_group'] = 'ntp'
default['ntp']['leapfile'] = '/etc/ntp.leapseconds'
default['ntp']['sync_clock'] = false
default['ntp']['sync_hw_clock'] = false
default['ntp']['listen'] = nil
default['ntp']['listen_network'] = nil
default['ntp']['ignore'] = nil
default['ntp']['apparmor_enabled'] = false
default['ntp']['monitor'] = false
default['ntp']['statistics'] = true
default['ntp']['conf_restart_immediate'] = false
default['ntp']['keys'] = nil
default['ntp']['trustedkey'] = nil
default['ntp']['requestkey'] = nil

# See http://www.vmware.com/vmtn/resources/238 p. 23 for explanation
default['ntp']['disable_tinker_panic_on_virtualization_guest'] = true

default['ntp']['peer']['key'] = nil
default['ntp']['peer']['use_iburst'] = true
default['ntp']['peer']['use_burst'] = false
default['ntp']['peer']['minpoll'] = 6
default['ntp']['peer']['maxpoll'] = 10

default['ntp']['server']['prefer'] = ''
default['ntp']['server']['use_iburst'] = true
default['ntp']['server']['use_burst'] = false
default['ntp']['server']['minpoll'] = 6
default['ntp']['server']['maxpoll'] = 10

default['ntp']['tinker']['allan'] = 1500
default['ntp']['tinker']['dispersion'] = 15
default['ntp']['tinker']['panic'] = 1000
default['ntp']['tinker']['step'] = 0.128
default['ntp']['tinker']['stepout'] = 900

default['ntp']['orphan']['enabled'] = false
default['ntp']['orphan']['stratum'] = 5 # ntp recommends 2 more than the worst-case externally-reachable source of time

# Set to true if using ntp < 4.2.8 or any unpatched ntp version to mitigate CVE-2014-9293 / CVE-2014-9294 / CVE-2014-9295
default['ntp']['localhost']['noquery'] = false

# overrides on a platform-by-platform basis
case node['platform_family']
when 'debian'
  default['ntp']['service'] = 'ntp'
  default['ntp']['apparmor_enabled'] = true if File.exist? '/etc/init.d/apparmor'
when 'rhel', 'fedora', 'amazon'
  default['ntp']['packages'] = %w(ntp ntpdate) if node['platform_version'].to_i >= 7
  default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/drift"
when 'windows'
  default['ntp']['service'] = 'NTP'
  default['ntp']['driftfile'] = 'C:\\NTP\\ntp.drift'
  default['ntp']['conffile'] = 'C:\\NTP\\etc\\ntp.conf'
  default['ntp']['conf_owner'] = 'Administrators'
  default['ntp']['conf_group'] = 'Administrators'
  default['ntp']['package_url'] = 'https://www.meinbergglobal.com/download/ntp/windows/ntp-4.2.8p10-win32-setup.exe'
  default['ntp']['statistics'] = false
when 'freebsd'
  default['ntp']['varlibdir'] = '/var/db'
  default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/ntpd.drift"
  default['ntp']['statsdir'] = "#{node['ntp']['varlibdir']}/ntpstats"
  default['ntp']['conf_group'] = 'wheel'
  default['ntp']['var_owner'] = 'root'
  default['ntp']['var_group'] = 'wheel'
when 'gentoo'
  default['ntp']['leapfile'] = "#{node['ntp']['varlibdir']}/ntp.leapseconds"
when 'solaris2'
  if node['platform_version'] < '5.11'
    default['ntp']['packages'] = %w(SUNWntpu SUNWntpr)
    default['ntp']['pkg_source'] = '/var/spool/pkg'
  end
  default['ntp']['service'] = 'ntp'
  default['ntp']['varlibdir'] = '/var/ntp'
  default['ntp']['conffile'] = '/etc/inet/ntp.conf'
  default['ntp']['statsdir'] = "#{node['ntp']['varlibdir']}/ntpstats/"
  default['ntp']['conf_owner'] = 'root'
  default['ntp']['conf_group'] = 'root'
  default['ntp']['var_owner'] = 'root'
  default['ntp']['var_group'] = 'sys'
  default['ntp']['leapfile'] = '/etc/inet/ntp.leap'
when 'pld'
  default['ntp']['packages'] = %w(ntpd)
  default['ntp']['conffile'] = '/etc/ntp/ntp.conf'
  default['ntp']['leapfile'] = '/etc/ntp/ntp.leapseconds'
  default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/drift"
  default['ntp']['var_owner'] = 'root'
when 'suse'
  default['ntp']['service'] = 'ntp' if node['platform_version'].to_f < 12
end

default['ntp']['use_cmos'] = !node['virtualization'] || node['virtualization']['role'] != 'guest' ? true : false
