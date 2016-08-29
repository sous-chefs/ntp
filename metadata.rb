name 'ntp'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs and configures ntp as a client or server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.0'

recipe 'ntp', 'Installs and configures ntp either as a server or client'

%w( amazon centos debian fedora freebsd gentoo redhat scientific solaris2 oracle ubuntu windows xcp ).each do |os|
  supports os
end

depends 'windows', '>= 1.38.0'

source_url 'https://github.com/chef-cookbooks/ntp' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/ntp/issues' if respond_to?(:issues_url)

chef_version '>= 11' if respond_to?(:chef_version)
