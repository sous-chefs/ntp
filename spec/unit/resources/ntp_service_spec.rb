# frozen_string_literal: true

require 'spec_helper'

describe 'ntp_service' do
  chefspec_options[:cookbook_path] = [File.expand_path('../../..', __dir__)]

  context 'on ubuntu 24.04' do
    step_into :ntp_service
    platform 'ubuntu', '24.04'

    recipe do
      resource = Chef::Resource.resource_for_node(:ntp_service, node).new('default', run_context)
      run_context.resource_collection.insert(resource)
    end

    it { is_expected.to install_package('ntpsec') }
    it { is_expected.to create_directory('/var/lib/ntpsec') }
    it { is_expected.to create_directory('/var/log/ntpsec') }
    it { is_expected.to create_template('/etc/ntpsec/ntp.conf') }
    it { is_expected.to enable_service('ntpsec') }
    it { is_expected.to start_service('ntpsec') }
  end

  context 'with sync_clock enabled' do
    step_into :ntp_service
    platform 'debian', '12'

    recipe do
      resource = Chef::Resource.resource_for_node(:ntp_service, node).new('default', run_context)
      resource.servers(['time.example.com'])
      resource.pools([])
      resource.sync_clock(true)
      resource.sync_clock_source('time.example.com')
      run_context.resource_collection.insert(resource)
    end

    it { is_expected.to install_package('ntpsec-ntpdate') }
    it { is_expected.to run_execute('sync system clock with ntp source').with(command: 'ntpdate -u time.example.com') }
  end

  context 'on redhat 9' do
    step_into :ntp_service
    platform 'redhat', '9'

    recipe do
      resource = Chef::Resource.resource_for_node(:ntp_service, node).new('default', run_context)
      run_context.resource_collection.insert(resource)
    end

    it { is_expected.to install_package('ntpsec') }
    it { is_expected.to create_directory('/var/lib/ntp') }
    it { is_expected.to create_directory('/var/log/ntpstats') }
    it { is_expected.to create_template('/etc/ntp.conf') }
    it { is_expected.to enable_service('ntpd') }
    it { is_expected.to start_service('ntpd') }
  end

  context 'with sync_clock enabled on redhat 9' do
    step_into :ntp_service
    platform 'redhat', '9'

    recipe do
      resource = Chef::Resource.resource_for_node(:ntp_service, node).new('default', run_context)
      resource.sync_clock(true)
      run_context.resource_collection.insert(resource)
    end

    it { is_expected.not_to install_package('ntpsec-ntpdate') }
    it { is_expected.to run_execute('sync system clock with ntp source').with(command: 'ntpd -q -u ntp') }
  end
end
