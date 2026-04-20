# frozen_string_literal: true

package 'epel-release' do
  action :install
  only_if { platform_family?('rhel') }
end

ntp_service 'default' do
  servers %w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org)
  pools []
  sync_clock false
end
