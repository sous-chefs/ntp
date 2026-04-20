# frozen_string_literal: true

ntp_service 'default' do
  servers ['time.example.com']
  pools []
  sync_clock true
  sync_clock_source 'time.example.com'
end
