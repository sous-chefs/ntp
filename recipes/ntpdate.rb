#
# Cookbook Name:: ntp
# Recipe:: ntpdate
# Author:: Eric G. Wolfe
#
# Copyright 2012, Eric G. Wolfe
# Copyright 2009, Opscode, Inc
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

# ntpdate is only available as a separate package on debian-based distros.
# Other distributions should use the default recipe.

if platform_family?("debian")
  package "ntpdate"

  unless node['ntp']['servers'].size > 0
    node.default['ntp']['servers'] = [
      "0.pool.ntp.org",
      "1.pool.ntp.org",
      "2.pool.ntp.org",
      "3.pool.ntp.org"
    ]
    log "No NTP servers specified, using default ntp.org server pools"
  end

  template "/etc/default/ntpdate" do
    owner node['ntp']['conf_owner']
    group node['ntp']['conf_group']
    mode "0644"
    variables(
      :disable => node['ntp']['ntpdate']['disable']
    )
  end
end
