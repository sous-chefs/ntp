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
require File.join(File.dirname(__FILE__), %w{.. support spec_helper})
require 'chef/platform'

describe 'Ntp::Attributes::Default' do
  let(:attr_ns) { 'ntp' }

  before do
    @node = Chef::Node.new
    @node.consume_external_attrs(Mash.new(ohai_data), {})
    @node.from_file(File.join(File.dirname(__FILE__), %w{.. .. attributes default.rb}))
  end

  describe "for unknown platform" do
    let(:ohai_data) do
      { :platform => "unknown", :platform_version => '3.14' }
    end

    it "sets the /var/lib directory" do
      @node[attr_ns]['varlibdir'].must_equal "/var/lib/ntp"
    end

    it "sets the driftfile to ntp.drift" do
      @node[attr_ns]['driftfile'].must_equal "/var/lib/ntp/ntp.drift"
    end

    it "sets the stats directory to /var/log/ntpstats/" do
      @node[attr_ns]['statsdir'].must_equal "/var/log/ntpstats/"
    end

    it "sets a packages list" do
      @node[attr_ns]['packages'].sort.must_equal %w{ ntp ntpdate }.sort
    end

    it "sets the service name to ntp" do
      @node[attr_ns]['service'].must_equal "ntp"
    end

    it "sets the conf_group to root" do
      @node[attr_ns]['conf_owner'].must_equal "root"
    end

    it "sets the conf_group to root" do
      @node[attr_ns]['conf_group'].must_equal "root"
    end

    it "sets the var_user to root" do
      @node[attr_ns]['var_owner'].must_equal "ntp"
    end

    it "sets the var_group to root" do
      @node[attr_ns]['var_group'].must_equal "ntp"
    end

    it "sets the upstream server list" do
      @node[attr_ns]['servers'].must_include "0.pool.ntp.org"
    end
  end

  describe "for centos 5 platform" do
    let(:ohai_data) do
      { :platform => "centos", :platform_version => '5.7' }
    end

    it "sets the service name to ntpd" do
      @node[attr_ns]['service'].must_equal "ntpd"
    end

    it "sets a packages list" do
      @node[attr_ns]['packages'].must_include "ntp"
    end
  end

  describe "for centos 6 platform" do
    let(:ohai_data) do
      { :platform => "centos", :platform_version => '6.2' }
    end

    it "sets the service name to ntpd" do
      @node[attr_ns]['service'].must_equal "ntpd"
    end

    it "sets a packages list" do
      @node[attr_ns]['packages'].sort.must_equal %w{ ntp ntpdate }.sort
    end
  end

  describe "for freebsd platform" do
    let(:ohai_data) do
      { :platform => "freebsd", :platform_version => '9.9' }
    end

    it "sets the service name to ntpd" do
      @node[attr_ns]['service'].must_equal "ntpd"
    end

    it "sets the drift file to ntpd.drift" do
      @node[attr_ns]['driftfile'].must_equal "/var/db/ntpd.drift"
    end

    it "sets the var directories to /var/db" do
      @node[attr_ns]['varlibdir'].must_equal "/var/db"
    end

    it "sets the stats directory to /var/db/ntpstats" do
      @node[attr_ns]['statsdir'].must_equal "/var/db/ntpstats"
    end

    it "sets the ntp packages to ntp" do
      @node[attr_ns]['packages'].must_include "ntp"
    end

    it "sets the conf_group to wheel" do
      @node[attr_ns]['conf_group'].must_equal "wheel"
    end

    it "sets the var_group to wheel" do
      @node[attr_ns]['var_group'].must_equal "wheel"
    end
  end
end
