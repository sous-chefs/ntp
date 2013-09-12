require 'spec_helper'

describe "ntp::apparmor" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new()
    runner.converge('recipe[ntp::apparmor]')
  end

  it "creates the apparmor file" do
    expect(chef_run).to create_cookbook_file '/etc/apparmor.d/usr.sbin.ntpd'
    file = chef_run.cookbook_file('/etc/apparmor.d/usr.sbin.ntpd')
    expect(file).to be_owned_by('root', 'root')
  end

  it "restarts the apparmor service" do
    expect(chef_run).to restart_service 'apparmor'
  end

end
