require 'spec_helper'

describe "ntp::ntpdate" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(
      log_level: :error,
    )
    Chef::Config.force_logger true
    runner.converge('recipe[ntp::ntpdate]')
  end

# Ideally this suite would default to not_to install_package
# in the mainline tests, and then in a debian context it would
# verify that things installed. However, Chefspec doesn't respect
# only_if.

# Standard test set
  it "installs ntpdate" do
    expect(chef_run).to install_package "ntpdate"
  end

  it "Creates the /etc/default/ntpdate file" do
    expect(chef_run).to create_file '/etc/default/ntpdate'
    file = chef_run.template('/etc/default/ntpdate')
    expect(file).to be_owned_by('root', 'root')
  end

end
