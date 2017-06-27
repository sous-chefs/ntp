#
# Cookbook:: ntp
# Recipe:: mac_os_x_client
# Author:: Antek S. Baranski (<antek.baranski@gmail.com>)
#
# Copyright:: 2016-2017, Roblox, Inc
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

# Do not continue if trying to run the Mac OS X recipe on non-OS X platform
return 'The ntp::mac_os_x_client recipe only supports Mac OS X' unless platform_family?('mac_os_x')

# Mac OS X 10.11+ does not allow for many NTP settings
execute 'set_ntp_server' do
  command "systemsetup -setnetworktimeserver #{node['ntp']['servers'][0]}"
  not_if "systemsetup -getnetworktimeserver | grep -F #{node['ntp']['servers'][0]}"
end

execute 'enable_ntp' do
  command 'systemsetup -setusingnetworktime on'
  not_if 'systemsetup -getusingnetworktime | grep On'
end
