#
# Cookbook:: ntp
# Recipe:: default
# Author:: Joshua Timberman (<joshua@chef.io>)
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Copyright:: 2009-2019, Chef Software, Inc.
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

if platform_family?('rhel') && node['platform_version'].to_i >= 8
  Chef::Log.warn('The NTP cookbook is not suupported on RHEL 8+ as NTP no longer ships in the OS')
  return
end

::Chef::DSL::Resources.include Opscode::Ntp::Helper
::Chef::Resource::Template.include Opscode::Ntp::Helper

# If there are no specified servers, pools, or peers, set some defaults.
# See COOK-1170 for why this isn't a default attribute
if (node['ntp']['servers'] + node['ntp']['peers'] + node['ntp']['pools']).empty?
  node.default['ntp']['servers'] = [
    '0.pool.ntp.org',
    '1.pool.ntp.org',
    '2.pool.ntp.org',
    '3.pool.ntp.org',
  ]
  Chef::Log.debug 'No NTP servers specified, using default ntp.org server pools'
end

case node['platform_family']
when 'windows'
  include_recipe 'ntp::windows_client'
when 'mac_os_x'
  include_recipe 'ntp::mac_os_x_client'
  # On macOS we only support simple client config and nothing more
  return 0
else

  node['ntp']['packages'].each do |ntppkg|
    package ntppkg do
      source node['ntp']['pkg_source']
      action :install
      # Non-interactive package install fails on Solaris10 so we need to manually the ntp package
      not_if { platform_family?('solaris2') && node['platform_version'].to_f <= 5.10 }
    end
  end

  package 'Remove ntpdate' do
    package_name 'ntpdate'
    action :remove
    only_if { platform_family?('debian') && node['platform_version'].to_i >= 16 }
  end

  [node['ntp']['varlibdir'], node['ntp']['statsdir']].each do |ntpdir|
    directory ntpdir do
      owner node['ntp']['var_owner']
      group node['ntp']['var_group']
      mode '0755'
    end
  end

  remote_file node['ntp']['leapfile'] do
    owner node['ntp']['conf_owner']
    group node['ntp']['conf_group']
    mode '0644'
    source node['ntp']['leapfile_url']
    notifies :restart, "service[#{node['ntp']['service']}]"
  end

  include_recipe 'ntp::apparmor' if node['ntp']['apparmor_enabled']
end

if node['ntp']['listen'].nil? && !node['ntp']['listen_network'].nil?
  if node['ntp']['listen_network'] == 'primary'
    node.normal['ntp']['listen'] = node['ipaddress']
  else
    require 'ipaddr'
    net = IPAddr.new(node['ntp']['listen_network'])

    node['network']['interfaces'].each do |_iface, addrs|
      addrs['addresses'].each do |ip, params|
        addr = IPAddr.new(ip) if params['family'].eql?('inet') || params['family'].eql?('inet6')
        node.normal['ntp']['listen'] = addr if net.include?(addr)
      end
    end
  end
end

node.default['ntp']['tinker']['panic'] = 0 if node['virtualization'] &&
                                              node['virtualization']['role'] == 'guest' &&
                                              node['ntp']['disable_tinker_panic_on_virtualization_guest']

template node['ntp']['conffile'] do
  source 'ntp.conf.erb'
  owner node['ntp']['conf_owner']
  group node['ntp']['conf_group']
  mode '0644'
  notifies :restart, "service[#{node['ntp']['service']}]" unless node['ntp']['conf_restart_immediate']
  notifies :restart, "service[#{node['ntp']['service']}]", :immediately if node['ntp']['conf_restart_immediate']
  variables(
    lazy { { ntpd_supports_native_leapfiles: ntpd_supports_native_leapfiles } }
  )
end

if node['ntp']['sync_clock'] && !platform_family?('windows')
  execute "Stop #{node['ntp']['service']} in preparation for ntpdate" do
    command platform_family?('freebsd') ? '/usr/bin/true' : '/bin/true'
    action :run
    notifies :stop, "service[#{node['ntp']['service']}]", :immediately
  end

  execute 'Force sync system clock with ntp server' do
    command case node['platform_family']
            when 'freebsd'
              'ntpd -q'
            when 'solaris2', 'aix'
              "ntpdate #{node['ntp']['servers'].sample}"
            else
              "ntpd -q -u #{node['ntp']['var_owner']}"
            end
    action :run
    notifies :start, "service[#{node['ntp']['service']}]"
  end
end

execute 'Force sync hardware clock with system clock' do
  command 'hwclock --systohc'
  action :run
  only_if { node['ntp']['sync_hw_clock'] && !platform_family?('windows', 'solaris2', 'freebsd') }
end

service node['ntp']['service'] do
  supports status: true, restart: true
  action [:enable, :start]
  timeout 120 if platform_family?('windows')
  retries 3
  retry_delay 5
end
