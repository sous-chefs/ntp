name 'ntp'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs and configures ntp as a client or server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.3.1'

recipe 'ntp', 'Installs and configures ntp either as a server or client'

%w( amazon centos debian fedora freebsd gentoo redhat scientific solaris2 oracle ubuntu windows mac_os_x ).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/ntp'
issues_url 'https://github.com/chef-cookbooks/ntp/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)
