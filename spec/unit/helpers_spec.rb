# frozen_string_literal: true

require 'spec_helper'
require_relative '../../libraries/helpers'
require 'ostruct'

describe NtpCookbook::Helpers do
  let(:helper_class) do
    Class.new do
      include NtpCookbook::Helpers

      attr_reader :node

      def initialize(node)
        @node = node
      end
    end
  end

  context 'on ubuntu 24.04' do
    let(:node) do
      Chef::Node.new.tap do |n|
        n.automatic['platform'] = 'ubuntu'
        n.automatic['platform_version'] = '24.04'
        n.automatic['ipaddress'] = '192.0.2.10'
      end
    end

    it 'reports the platform as supported' do
      expect(helper_class.new(node).supported_platform?).to be true
    end
  end

  context 'with a primary listen network' do
    let(:node) do
      Chef::Node.new.tap do |n|
        n.automatic['platform'] = 'debian'
        n.automatic['platform_version'] = '12'
        n.automatic['ipaddress'] = '192.0.2.20'
      end
    end

    it 'returns the node ip for the primary network' do
      expect(helper_class.new(node).resolved_listen_addresses(nil, 'primary')).to eq(['192.0.2.20'])
    end
  end

  context 'with default ntp settings' do
    let(:node) do
      Chef::Node.new.tap do |n|
        n.automatic['platform'] = 'ubuntu'
        n.automatic['platform_version'] = '24.04'
        n.automatic['ipaddress'] = '192.0.2.30'
        n.automatic['fqdn'] = 'ntp.example.test'
      end
    end

    let(:resource) do
      OpenStruct.new(
        driftfile: '/var/lib/ntpsec/ntp.drift',
        statsdir: '/var/log/ntpsec',
        leapfile: '/usr/share/zoneinfo/leap-seconds.list',
        logfile: nil,
        logconfig: 'all',
        statistics: true,
        ignore: nil,
        listen: nil,
        listen_network: nil,
        peers: [],
        servers: %w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org),
        pools: [],
        restrict_default: 'limited kod notrap nomodify nopeer noquery',
        restrictions: [],
        monitor: false,
        localhost: { noquery: false },
        orphan: { enabled: false, stratum: 5 },
        peer: { key: nil, use_iburst: true, use_burst: false, minpoll: 6, maxpoll: 10 },
        server: { prefer: '', use_iburst: true, use_burst: false, minpoll: 6, maxpoll: 10 },
        tinker: { allan: 1500, dispersion: 15, panic: 1000, step: 0.128, stepout: 900 },
        tos: { maxdist: 1 },
        keys: nil,
        trustedkey: nil,
        requestkey: nil,
        dscp: nil,
        disable_tinker_panic_on_virtualization_guest: true
      )
    end

    it 'builds the expected config hash' do
      config = helper_class.new(node).config_hash(resource)

      expect(config[:servers]).to eq(%w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org))
      expect(config[:tos_maxdist]).to eq(1)
      expect(config[:tinker][:panic]).to eq(1000)
    end
  end
end
