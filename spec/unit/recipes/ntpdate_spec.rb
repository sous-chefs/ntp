require 'spec_helper'

describe "ntp::ntpdate" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new()
    runner.converge('recipe[ntp::ntpdate]')
  end

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
