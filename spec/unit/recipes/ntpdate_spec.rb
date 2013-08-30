require 'spec_helper'

describe "ntp::ntpdate" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new()
    runner.converge('recipe[ntp::ntpdate]')
  end

# Ideally this suite would default to not_to install_package
# in the mainline tests, and then in a debian context it would
# verify that things installed. However, Chefspec doesn't respect
# only_if.

# Standard test set
  it "Does not install the ntpdate package" do
    expect(chef_run).not_to install_package "ntpdate"
  end

  it "Does not create the /etc/default/ntpdate file" do
    expect(chef_run).not_to create_file '/etc/default/ntpdate'
  end

  context "Ubuntu" do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
      runner.converge('recipe[ntp::disable]')
    end

    it "Installs the ntpdate package" do
      expect(chef_run).to install_package "ntpdate"
    end

    it "Creates the /etc/default/ntpdate file" do
      file = chef_run.template('/etc/default/ntpdate')
      expect(file).to be_owned_by('root', 'root')
      expect(chef_run).to create_file_with_content '/etc/default/ntpdate', "0.pool.ntp.org"
    end
  end

end
