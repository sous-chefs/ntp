#
# Cookbook Name:: ntp
# Recipe:: default
# Author:: Joshua Timberman (<joshua@opscode.com>)
#
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

root_group = node['ntp']['root_group']

case node[:platform]
when "ubuntu","debian"
  package "ntpdate" do
    action :install
  end
  package "ntp" do
    action :install
  end
when "redhat","centos","fedora","scientific"
  package "ntp" do
    action :install
  end
  package "ntpdate" do
    action :install
  end unless node[:platform_version].to_i < 6
end

case node[:platform]
when "freebsd"
  directory node[:ntp][:statsdir] do
    owner "root"
    group root_group
    mode "0755"
  end
when "redhat","centos","fedora","scientific"
  # ntpstats dir doesn't exist on RHEL/CentOS
else
  directory node[:ntp][:statsdir] do
    owner "ntp"
    group "ntp"
    mode "0755"
  end
end

service node[:ntp][:service] do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group root_group
  mode "0644"
  notifies :restart, resources(:service => node[:ntp][:service])
end
