# frozen_string_literal: true

ntp_service 'default' do
  servers %w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org)
  pools []
  sync_clock false
end
