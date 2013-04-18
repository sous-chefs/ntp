#
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
# Cookbook Name:: ntp
# Recipe:: disable
#

service node['ntp']['service'] do
	action [ :disable, :stop ]
end

node.default['ntp']['ntpdate']['disable'] = true
include_recipe "ntp::ntpdate"
