#
# Cookbook Name:: ntp
# Test:: attributes_spec
#
# Author:: Fletcher Nichol
# Author:: Eric G. Wolfe
#
# Copyright 2012, Fletcher Nichol
# Copyright 2012, Eric G. Wolfe
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
  let(:chef_run) { ChefSpec::ChefRunner.new.converge('ntp::default') }
  let(:ntp) { chef_run.node['ntp'] }
  # let(:attr_ns) { 'ntp' }

  # before do
  #   @node = Chef::Node.new
  #   @node.consume_external_attrs(Mash.new(ohai_data), {})
  #   @node.from_file(File.join(File.dirname(__FILE__), %w{.. .. attributes default.rb}))
  # end

  describe 'an unknown platform' do
    it 'sets the /var/lib directory' do
      expect(ntp['varlibdir']).to eq('/var/lib/ntp')
    end

    it 'sets the driftfile to ntp.drift' do
      expect(ntp['driftfile']).to eq('/var/lib/ntp/ntp.drift')
    end

    it 'sets the stats directory to /var/log/ntpstats/' do
      expect(ntp['statsdir']).to eq('/var/log/ntpstats/')
    end

    it 'sets a packages list' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).to include('ntpdate')
    end

    it 'sets the service name to ntp' do
      expect(ntp['service']).to eq('ntp')
    end

    it 'sets the conf_group to root' do
      expect(ntp['conf_owner']).to eq('root')
    end

    it 'sets the conf_group to root' do
      expect(ntp['conf_group']).to eq('root')
    end

    it 'sets the var_user to root' do
      expect(ntp['var_owner']).to eq('ntp')
    end

    it 'sets the var_group to root' do
      expect(ntp['var_group']).to eq('ntp')
    end

    it 'sets the upstream server list' do
      expect(ntp['servers']).to include('0.pool.ntp.org')
    end
  end

  describe 'on CentOS' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'centos', version: '6.4').converge('ntp::default') }

    it 'sets the service name to ntpd' do
      expect(ntp['service']).to eq('ntpd')
    end

    it 'sets a packages list' do
      expect(ntp['packages']).to include('ntp')
      expect(ntp['packages']).to include('ntpdate')
    end
  end

  describe 'on FreeBSD' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'freebsd', version: '9.1').converge('ntp::default') }

    it 'sets the service name to ntpd' do
      expect(ntp['service']).to eq('ntpd')
    end

    it 'sets the drift file to ntpd.drift' do
      expect(ntp['driftfile']).to eq('/var/db/ntpd.drift')
    end

    it 'sets the var directories to /var/db' do
      expect(ntp['varlibdir']).to eq('/var/db')
    end

    it 'sets the stats directory to /var/db/ntpstats' do
      expect(ntp['statsdir']).to eq('/var/db/ntpstats')
    end

    it 'sets the ntp packages to ntp' do
      expect(ntp['packages']).to include('ntp')
    end

    it 'sets the conf_group to wheel' do
      expect(ntp['conf_group']).to eq('wheel')
    end

    it 'sets the var_group to wheel' do
      expect(ntp['var_group']).to eq('wheel')
    end
  end
end
