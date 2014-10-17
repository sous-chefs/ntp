require 'spec_helper'

describe 'ntp::apparmor' do
  let(:chef_run) { ChefSpec::Runner.new.converge('recipe[ntp::apparmor]') }

  it 'creates the apparmor file' do
    expect(chef_run).to create_cookbook_file('/etc/apparmor.d/usr.sbin.ntpd').with(
        user: 'root',
        group: 'root'
    )
  end

  it 'restarts the apparmor service' do
    resource = chef_run.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')
    expect(resource).to notify('service[apparmor]').to(:restart)
  end

end
