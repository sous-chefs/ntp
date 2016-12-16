require 'spec_helper'

describe 'ntp::mac_os_x_client' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.11.1').converge('ntp::mac_os_x_client') }

  it 'executes systemsetup -setnetworktimeserver' do
    expect(chef_run).to run_execute('systemsetup -setnetworktimeserver')
  end

  it 'executes systemsetup -setusingnetworktime on' do
    expect(chef_run).to run_execute('systemsetup -setusingnetworktime')
  end
end
