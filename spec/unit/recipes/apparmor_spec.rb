require 'spec_helper'

describe 'ntp::apparmor' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge('recipe[ntp::apparmor]') }

  it 'creates the apparmor file' do
    cr = chef_run
    expect(cr).to create_cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')
    expect(cr).to render_file('/etc/apparmor.d/usr.sbin.ntpd')
      .with_content(%r{^/usr/sbin/ntpd flags=\(attach_disconnected\)})
    expect(cr).to render_file('/etc/apparmor.d/usr.sbin.ntpd')
      .with_content(/ntp.conf.dhcp r/)
    file = cr.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')
    expect(file.owner).to eq('root')
    expect(file.group).to eq('root')
  end

  it 'restarts the apparmor service' do
    expect(chef_run.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')).to notify('service[apparmor]').to(:restart)
  end
end
