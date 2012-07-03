#
# Cookbook Name:: ntp
# Attributes:: default
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
#
# Copyright 2009-2011, Opscode, Inc.
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
default[:ntp][:is_server] = false
default[:ntp][:driftfile] = "/var/lib/ntp/ntp.drift"
default[:ntp][:statsdir] = "/var/log/ntpstats/"
default[:ntp][:leapfile] = "/etc/ntp.leapseconds"

# overrides on a platform-by-platform basis
case platform
when "ubuntu","debian"
  default[:ntp][:service] = "ntp"
  default[:ntp][:root_group] = "root"
when "redhat","centos","fedora","scientific"
  default[:ntp][:service] = "ntpd"
  default[:ntp][:root_group] = "root"
when "freebsd"
  default[:ntp][:service] = "ntpd"
  default[:ntp][:root_group] = "wheel"
  default[:ntp][:driftfile] = "/var/db/ntpd.drift"
  default[:ntp][:statsdir] = "/var/db/ntpstats/"
else
  default[:ntp][:service] = "ntpd"
  default[:ntp][:root_group] = "root"
end

case platform
when "ubuntu"
  default[:ntp][:servers]   = [ "ntp.ubuntu.com" ]
when "debian"
  default[:ntp][:servers] = [ "0.debian.pool.ntp.org", "1.debian.pool.ntp.org", "2.debian.pool.ntp.org", "3.debian.pool.ntp.org" ]
when "redhat"
  default[:ntp][:servers] = [ "0.rhel.pool.ntp.org", "1.rhel.pool.ntp.org", "2.rhel.pool.ntp.org" ]
else
  default[:ntp][:servers] = [ "0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org" ]
end

default[:ntp][:peers] = []
default[:ntp][:restrictions] = []
