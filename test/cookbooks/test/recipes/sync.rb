# frozen_string_literal: true

package 'epel-release' do
  action :install
  only_if { platform_family?('rhel') }
end

ntp_service 'default' do
  servers ['time.example.com']
  pools []
  sync_clock true
  sync_clock_source 'time.example.com'
end
