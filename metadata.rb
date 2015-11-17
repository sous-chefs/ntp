name              'ntp'
maintainer        'George Miranda'
maintainer_email  'gmiranda@chef.io'
license           'Apache 2.0'
description       'Installs and configures ntp as a client or server'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.8.6'

recipe 'ntp', 'Installs and configures ntp either as a server or client'

%w( amazon centos debian fedora freebsd gentoo redhat scientific solaris2 oracle ubuntu windows xcp ).each do |os|
  supports os
end

suggests 'windows'

