name 'ntp'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs and configures ntp as a client or server'
version '3.6.2'

%w( amazon centos debian fedora freebsd gentoo redhat scientific solaris2 oracle ubuntu windows mac_os_x opensuseleap ).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/ntp'
issues_url 'https://github.com/chef-cookbooks/ntp/issues'
chef_version '>= 12.1'
