#
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
# Cookbook Name:: ntp
# Recipe:: disable
#

root_group = node['ntp']['root_group']

service node['ntp']['service'] do
	action [ :disable, :stop ]
end

case node['platform']
when "ubuntu","debian"
	template "/etc/default/ntpdate" do
		source "ntpdate.erb"
		owner "root"
		group root_group
		mode "0644"
		variables(
			:disable => TRUE
		)
	end
end
