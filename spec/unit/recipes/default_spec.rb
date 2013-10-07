require 'spec_helper'

describe 'ntp::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge('ntp::default') }

  it 'installs the ntp package' do
    expect(chef_run).to install_package('ntp')
  end

  it 'installs the ntpdate package' do
    expect(chef_run).to install_package('ntpdate')
  end

  context 'the varlibdir directory' do
    let(:directory) { chef_run.directory('/var/lib/ntp') }

    it 'creates the directory' do
      expect(chef_run).to create_directory('/var/lib/ntp')
    end

    it 'is owned by ntp:ntp' do
      expect(directory.owner).to eq('ntp')
      expect(directory.group).to eq('ntp')
    end

    it 'has 0755 permissions' do
      expect(directory.mode).to eq('0755')
    end
  end

  context 'the statsdir directory' do
    let(:directory) { chef_run.directory('/var/log/ntpstats/') }

    it 'creates the directory' do
      expect(chef_run).to create_directory('/var/log/ntpstats/')
    end

    it 'is owned by ntp:ntp' do
      expect(directory.owner).to eq('ntp')
      expect(directory.group).to eq('ntp')
    end

    it 'has 0755 permissions' do
      expect(directory.mode).to eq('0755')
    end
  end

  context 'the leapfile' do
    let(:cookbook_file) { chef_run.cookbook_file('/etc/ntp.leapseconds') }

    it 'creates the cookbook_file' do
      expect(chef_run).to create_cookbook_file('/etc/ntp.leapseconds')
    end

    it 'is owned by ntp:ntp' do
      expect(cookbook_file.owner).to eq('root')
      expect(cookbook_file.group).to eq('root')
    end

    it 'has 0644 permissions' do
      expect(cookbook_file.mode).to eq('0644')
    end
  end

  context 'the ntp.conf' do
    let(:template) { chef_run.template('/etc/ntp.conf') }

    it 'creates the template' do
      expect(chef_run).to create_file('/etc/ntp.conf')
    end

    it 'is owned by ntp:ntp' do
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
    end

    it 'has 0644 permissions' do
      expect(template.mode).to eq('0644')
    end
  end

  it 'does not execute the "Force sync system clock with ntp server" command' do
    expect(chef_run).not_to execute_command('ntpd -q')
  end

  it 'does not execute the "Force sync hardware clock with system clock" command' do
    expect(chef_run).not_to execute_command('hwclock --systohc')
  end

  it 'starts the ntpd service' do
    expect(chef_run).to start_service('ntpd')
  end

  it 'sets ntpd to start on boot' do
    expect(chef_run).to set_service_to_start_on_boot('ntpd')
  end

  context 'the sync_clock attribute is set' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new
      runner.node.set['ntp']['sync_clock'] = true
      runner.converge('ntp::default')
    end

    it 'executes the "Force sync system clock with ntp server" command' do
      expect(chef_run).to execute_command('ntpd -q')
    end
  end

  context 'the sync_hw_clock attribute is set on a non-Windows OS' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new
      runner.node.set['ntp']['sync_hw_clock'] = true
      runner.converge('ntp::default')
    end

    it 'executes the "Force sync hardware clock with system clock" command' do
      expect(chef_run).to execute_command('hwclock --systohc')
    end
  end

  context 'the sync_hw_clock attribute is set on a Windows OS' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform: 'windows', version: '2008R2')
      runner.node.set['ntp']['sync_hw_clock'] = true
      runner.converge('ntp::default')
    end

    it 'does not executes the "Force sync hardware clock with system clock" command' do
      pending('ChefSpec does not yet understand the inherits attribute in cookbook_file resources')
      expect(chef_run).not_to execute_command('hwclock --systohc')
    end
  end

  context 'on CentOS 5' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'centos', version: '5.8').converge('ntp::default') }

    it 'installs the ntp package' do
      expect(chef_run).to install_package('ntp')
    end

    it 'does not install the ntpdate package' do
      expect(chef_run).to_not install_package('ntpdate')
    end

    it 'sets ntpd to start on boot' do
      expect(chef_run).to set_service_to_start_on_boot('ntpd')
    end
  end

  context 'ubuntu' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').converge('ntp::default') }

    it 'starts the ntp service' do
      expect(chef_run).to start_service('ntp')
    end

    it 'sets ntp to start on boot' do
      expect(chef_run).to set_service_to_start_on_boot('ntp')
    end
  end

  context 'freebsd' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'freebsd', version: '9.1').converge('ntp::default') }

    it 'installs the ntp package' do
      expect(chef_run).to install_package('ntp')
    end

    it 'does not install the ntpdate package' do
      expect(chef_run).to_not install_package('ntpdate')
    end

    it 'sets ntpd to start on boot' do
      expect(chef_run).to set_service_to_start_on_boot('ntpd')
    end
  end
end
