require 'spec_helper'

describe "ntp::default" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new()
    runner.converge('recipe[ntp::default]')
  end

  it "installs both ntp and ntpdate" do
    expect(chef_run).to install_package "ntp"
    expect(chef_run).to install_package "ntpdate"
  end

  it "creates the varlibdir and statsdir directories" do
    expect(chef_run).to create_directory '/var/lib/ntp'
    directory = chef_run.directory('/var/lib/ntp')
    expect(directory).to be_owned_by('ntp', 'ntp')
    expect(chef_run).to create_directory '/var/log/ntpstats/'
    directory = chef_run.directory('/var/log/ntpstats/')
    expect(directory).to be_owned_by('ntp', 'ntp')
  end

  it "creates the leapfile" do
    expect(chef_run).to create_cookbook_file '/etc/ntp.leapseconds'
    file = chef_run.cookbook_file('/etc/ntp.leapseconds')
    expect(file).to be_owned_by('root', 'root')
  end

  it "Creates the ntp.conf file" do
    expect(chef_run).to create_file '/etc/ntp.conf'
    file = chef_run.template('/etc/ntp.conf')
    expect(file).to be_owned_by('root', 'root')
  end

  it "starts and enables the ntp service" do
    expect(chef_run).to start_service 'ntp'
    expect(chef_run).to set_service_to_start_on_boot 'ntp'
  end

#CentOS & friends 5 get different default attributes
  context "CentOS 5" do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(
        platform: 'centos',
        version: '5.8',
        log_level: :error,
      )
      Chef::Config.force_logger true
      runner.converge('recipe[ntp::default]')
    end

    it "installs only ntp, not ntpdate" do
      expect(chef_run).to install_package "ntp"
      expect(chef_run).not_to install_package "ntpdate"
    end

    it "starts and enables the ntpd service" do
      expect(chef_run).to start_service 'ntpd'
      expect(chef_run).to set_service_to_start_on_boot 'ntpd'
    end
  end

#CentOS & friends 6 get different default attributes
  context "CentOS 6" do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform:'centos', version:'6.3')
      runner.converge('recipe[ntp::default]')
    end

    it "starts and enables the ntpd service" do
      expect(chef_run).to start_service 'ntpd'
      expect(chef_run).to set_service_to_start_on_boot 'ntpd'
    end
  end

#FreeBSD gets different default attributes
  context "freebsd" do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform: 'freebsd', version: '9.1')
      runner.converge('recipe[ntp::default]')
    end

    it "installs only ntp, not ntpdate" do
      expect(chef_run).to install_package "ntp"
      expect(chef_run).not_to install_package "ntpdate"
    end

    it "creates the varlibdir and statsdir directories" do
      expect(chef_run).to create_directory '/var/db'
      directory = chef_run.directory('/var/db')
      expect(directory).to be_owned_by('ntp', 'wheel')
      expect(chef_run).to create_directory '/var/db/ntpstats'
      directory = chef_run.directory('/var/db/ntpstats')
      expect(directory).to be_owned_by('ntp', 'wheel')
    end

    it "starts and enables the ntpd service" do
      expect(chef_run).to start_service 'ntpd'
      expect(chef_run).to set_service_to_start_on_boot 'ntpd'
    end

    it "Creates the ntp.conf file" do
      expect(chef_run).to create_file '/etc/ntp.conf'
      file = chef_run.template('/etc/ntp.conf')
      expect(file).to be_owned_by('root', 'wheel')
    end
  end

end
