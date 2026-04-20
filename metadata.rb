# frozen_string_literal: true

name             'ntp'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Provides the ntp_service custom resource for managing distro-packaged NTPsec'
version          '7.0.0'
source_url       'https://github.com/sous-chefs/ntp'
issues_url       'https://github.com/sous-chefs/ntp/issues'
chef_version     '>= 16.0'

supports 'debian', '>= 12.0'
supports 'ubuntu', '>= 22.04'
supports 'almalinux', '>= 9.0'
supports 'centos', '>= 9.0'
supports 'oracle', '>= 9.0'
supports 'redhat', '>= 9.0'
supports 'rocky', '>= 9.0'
