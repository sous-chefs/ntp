require 'spec_helper'

describe 'ntp::windows_client' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge('ntp::windows_client') }

  it 'creates the C:/NTP/etc directory' do
    expect(chef_run).to create_directory('C:/NTP/etc')
  end

  it 'creates the C:/NTP/ntp.ini file' do
    expect(chef_run).to create_cookbook_file('C:/NTP/ntp.ini')
  end

  it 'Fetches the ntpd.exe via remote_file' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/ntpd.exe")
  end

  it 'Executes the ntpd installer' do
    expect(chef_run).to run_execute("#{Chef::Config[:file_cache_path]}\\ntpd.exe /USEFILE=C:\\NTP\\ntp.ini")
  end
end
