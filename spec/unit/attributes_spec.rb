#
# Cookbook:: ntp
# Test:: attributes_spec
#
# Author:: Fletcher Nichol
# Author:: Eric G. Wolfe
#
# Copyright:: 2012-2017, Fletcher Nichol
# Copyright:: 2012-2017, Eric G. Wolfe
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe 'ntp attributes' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'aix').converge('ntp::default') }
  let(:ntp) { chef_run.node['ntp'] }

  describe 'on an unknown platform' do
    it 'sets the package list to ntp' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).to_not include('ntpdate')
    end

    it 'sets the service name to ntpd' do
      expect(ntp['service']).to eq('ntpd')
    end

    it 'sets the /var/lib directory' do
      expect(ntp['varlibdir']).to eq('/var/lib/ntp')
    end

    it 'sets the driftfile to /var/lib/ntp.drift' do
      expect(ntp['driftfile']).to eq('/var/lib/ntp/ntp.drift')
    end

    it 'sets the logfile to nil' do
      expect(ntp['logfile']).to be nil
    end

    it 'sets the conf file to /etc/ntp.conf' do
      expect(ntp['conffile']).to eq('/etc/ntp.conf')
    end

    it 'sets the stats directory to /var/log/ntpstats/' do
      expect(ntp['statsdir']).to eq('/var/log/ntpstats/')
    end

    it 'sets restrict default to kod notrap nomodify nopeer noquery' do
      expect(ntp['restrict_default']).to eq('limited kod notrap nomodify nopeer noquery')
    end

    it 'sets the conf_owner to root' do
      expect(ntp['conf_owner']).to eq('root')
    end

    it 'sets the conf_group to root' do
      expect(ntp['conf_group']).to eq('root')
    end

    it 'sets the var_owner to root' do
      expect(ntp['var_owner']).to eq('ntp')
    end

    it 'sets the var_group to root' do
      expect(ntp['var_group']).to eq('ntp')
    end

    it 'sets the leapfile to /etc/ntp.leapseconds' do
      expect(ntp['leapfile']).to eq('/etc/ntp.leapseconds')
    end

    it 'sets the upstream server list in the recipe' do
      expect(ntp['servers']).to include('0.pool.ntp.org')
    end

    it 'sets apparmor_enabled to false' do
      expect(ntp['apparmor_enabled']).to eq(false)
    end

    it 'sets monitor to false' do
      expect(ntp['monitor']).to eq(false)
    end

    it 'sets the keys to nil' do
      expect(ntp['keys']).to be nil
    end

    it 'sets the trustedkey to nil' do
      expect(ntp['trustedkey']).to be nil
    end

    it 'sets the dscp to nil' do
      expect(ntp['dscp']).to be nil
    end

    it 'sets conf_restart_immediate to false' do
      expect(ntp['conf_restart_immediate']).to eq(false)
    end

    it 'sets peer key to nil' do
      expect(ntp['peer']['key']).to be nil
    end

    it 'sets peer use_iburst to true' do
      expect(ntp['peer']['use_iburst']).to eq(true)
    end

    it 'sets peer use_burst to false' do
      expect(ntp['peer']['use_burst']).to eq(false)
    end

    it 'sets peer minpoll to 6' do
      expect(ntp['peer']['minpoll']).to eq(6)
    end

    it 'sets peer maxpoll to 10' do
      expect(ntp['peer']['maxpoll']).to eq(10)
    end

    it 'sets server prefer to empty string' do
      expect(ntp['server']['prefer']).to eq('')
    end

    it 'sets server use_iburst to true' do
      expect(ntp['server']['use_iburst']).to eq(true)
    end

    it 'sets server use_burst to false' do
      expect(ntp['server']['use_burst']).to eq(false)
    end

    it 'sets server minpoll to 6' do
      expect(ntp['server']['minpoll']).to eq(6)
    end

    it 'sets server maxpoll to 10' do
      expect(ntp['server']['maxpoll']).to eq(10)
    end

    context 'tinker options' do
      it 'sets allan to 1500' do
        expect(ntp['tinker']['allan']).to eq(1500)
      end

      it 'sets dispersion to 15' do
        expect(ntp['tinker']['dispersion']).to eq(15)
      end

      it 'sets panic to 1000' do
        expect(ntp['tinker']['panic']).to eq(1000)
      end

      it 'sets step to 0.128' do
        expect(ntp['tinker']['step']).to eq(0.128)
      end

      it 'sets stepout to 900' do
        expect(ntp['tinker']['stepout']).to eq(900)
      end
    end
  end

  describe 'on Debian-family platforms' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'debian', version: '10').converge('ntp::default') }

    it 'sets the package list to ntp & ntpdate' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).to_not include('ntpdate')
    end
  end

  describe 'on Ubuntu' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge('ntp::default') }

    it 'sets the apparmor_enabled attribute to true when /etc/init.d/apparmor exists' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/init.d/apparmor').and_return(true)
      expect(ntp['apparmor_enabled']).to eq(true)
    end

    it 'sets the apparmor_enabled attribute to false when /etc/init.d/apparmor does not exist' do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/init.d/apparmor').and_return(false)
      expect(ntp['apparmor_enabled']).to eq(false)
    end
  end

  describe 'on the CentOS 7 platform' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '7').converge('ntp::default') }

    it 'sets the package list to include ntp and ntpdate' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).to include('ntpdate')
    end
  end

  describe 'on the Windows platform' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge('ntp::default') }

    it 'sets the service name to NTP' do
      expect(ntp['service']).to eq('NTP')
    end

    it 'sets the drift file to /var/db/ntpd.drift' do
      expect(ntp['driftfile']).to eq('C:\\NTP\\ntp.drift')
    end

    it 'sets the conf file to /etc/ntp.conf' do
      expect(ntp['conffile']).to eq('C:\\NTP\\etc\\ntp.conf')
    end

    it 'sets the conf_owner to root' do
      expect(ntp['conf_owner']).to eq('Administrators')
    end

    it 'sets the conf_group to root' do
      expect(ntp['conf_group']).to eq('Administrators')
    end

    it 'sets the package_url correctly' do
      expect(ntp['package_url']).to eq('https://www.meinbergglobal.com/download/ntp/windows/ntp-4.2.8p13-win32-setup.exe')
    end
  end

  describe 'on the FreeBSD platform' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'freebsd').converge('ntp::default') }

    it 'sets the package list to include only ntp' do
      expect(ntp['packages']).to include('ntp')
    end

    it 'sets the var directories to /var/db' do
      expect(ntp['varlibdir']).to eq('/var/db')
    end

    it 'sets the drift file to /var/db/ntpd.drift' do
      expect(ntp['driftfile']).to eq('/var/db/ntpd.drift')
    end

    it 'sets the stats directory to /var/db/ntpstats' do
      expect(ntp['statsdir']).to eq('/var/db/ntpstats')
    end

    it 'sets the conf_group to wheel' do
      expect(ntp['conf_group']).to eq('wheel')
    end

    it 'sets the var_owner to root' do
      expect(ntp['var_owner']).to eq('root')
    end

    it 'sets the var_group to wheel' do
      expect(ntp['var_group']).to eq('wheel')
    end
  end
end
