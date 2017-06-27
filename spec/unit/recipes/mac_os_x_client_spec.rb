require 'spec_helper'

describe 'ntp::mac_os_x_client' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'mac_os_x',
      version: '10.12'
    ) do |node|
      node.normal['ntp']['servers'] = %w(one two three)
    end.converge(described_recipe)
  end

  before do
    stub_command('systemsetup -getnetworktimeserver | grep -F one').and_return(false)
    stub_command('systemsetup -getusingnetworktime | grep On').and_return(false)
  end

  it 'executes systemsetup -setnetworktimeserver' do
    expect(chef_run).to run_execute('set_ntp_server').with_command('systemsetup -setnetworktimeserver one')
  end

  it 'executes systemsetup -setusingnetworktime on' do
    expect(chef_run).to run_execute('enable_ntp').with_command('systemsetup -setusingnetworktime on')
  end
end
