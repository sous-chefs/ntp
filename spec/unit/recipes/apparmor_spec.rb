require 'spec_helper'

describe 'ntp::apparmor' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge('recipe[ntp::apparmor]') }

  it 'creates the apparmor file' do
    expect(chef_run).to create_cookbook_file '/etc/apparmor.d/usr.sbin.ntpd'
    file = chef_run.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')
    expect(file).to be_owned_by('root', 'root')
  end

  it 'restarts the apparmor service' do
    chef_run.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd').should notify('service[apparmor]', :restart)
  end

end
