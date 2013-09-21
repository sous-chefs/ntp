require 'spec_helper'

describe 'ntp::undo' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge('ntp::undo') }

  it 'stops the ntp service' do
    expect(chef_run).to stop_service('ntp')
  end

  it 'sets the ntp service to start on boot' do
    expect(chef_run).to set_service_to_not_start_on_boot('ntp')
  end

  it 'uninstalls the ntp package' do
    expect(chef_run).to remove_package('ntp')
  end

  it 'uninstalls the ntpdate package' do
    expect(chef_run).to remove_package('ntpdate')
  end
end
