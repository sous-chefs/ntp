# frozen_string_literal: true

require_relative '../../spec_helper'

control 'ntp-default-package-01' do
  impact 1.0
  title 'The ntpsec package is installed'

  describe package('ntpsec') do
    it { should be_installed }
  end
end

control 'ntp-default-config-01' do
  impact 0.7
  title 'The ntp configuration file exists'

  describe file(ntp_config_path) do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('content') { should match(/server 0\.pool\.ntp\.org iburst minpoll 6 maxpoll 10/) }
  end
end

control 'ntp-default-service-01' do
  impact 0.5
  title 'The ntpsec service is enabled and running'

  describe service(ntp_service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end
