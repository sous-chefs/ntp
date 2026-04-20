# frozen_string_literal: true

require 'ipaddr'

module NtpCookbook
  module Helpers
    SUPPORTED_PLATFORMS = {
      'debian' => Gem::Requirement.new('>= 12'),
      'ubuntu' => Gem::Requirement.new('>= 22.04'),
    }.freeze

    EL9_PLATFORM_DEFAULTS = {
      package_name: 'ntpsec',
      sync_package_name: nil,
      service_name: 'ntpd',
      config_path: '/etc/ntp.conf',
      varlibdir: '/var/lib/ntp',
      statsdir: '/var/log/ntpstats',
      driftfile: '/var/lib/ntp/drift',
      leapfile: '/usr/share/zoneinfo/leapseconds',
      state_user: 'ntp',
      state_group: 'ntp',
    }.freeze

    DEB_NTPSEC_PLATFORM_DEFAULTS = {
      package_name: 'ntpsec',
      sync_package_name: 'ntpsec-ntpdate',
      service_name: 'ntpsec',
      config_path: '/etc/ntpsec/ntp.conf',
      varlibdir: '/var/lib/ntpsec',
      statsdir: '/var/log/ntpsec',
      driftfile: '/var/lib/ntpsec/ntp.drift',
      leapfile: '/usr/share/zoneinfo/leap-seconds.list',
      state_user: 'ntpsec',
      state_group: 'ntpsec',
    }.freeze

    def supported_platform?
      return true if el9_plus?

      requirement = SUPPORTED_PLATFORMS[node['platform']]
      return false if requirement.nil?

      requirement.satisfied_by?(Gem::Version.new(node['platform_version']))
    end

    def assert_supported_platform!
      return if supported_platform?

      raise Chef::Exceptions::UnsupportedPlatform,
            "ntp_service supports Debian 12+, Ubuntu 22.04+, and Enterprise Linux 9+. Found #{node['platform']} #{node['platform_version']}."
    end

    def default_servers
      %w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org)
    end

    def default_package_name
      platform_defaults.fetch(:package_name)
    end

    def default_sync_package_name
      platform_defaults.fetch(:sync_package_name)
    end

    def default_service_name
      platform_defaults.fetch(:service_name)
    end

    def default_config_path
      platform_defaults.fetch(:config_path)
    end

    def default_varlibdir
      platform_defaults.fetch(:varlibdir)
    end

    def default_statsdir
      platform_defaults.fetch(:statsdir)
    end

    def default_driftfile
      platform_defaults.fetch(:driftfile)
    end

    def default_leapfile
      platform_defaults.fetch(:leapfile)
    end

    def default_state_user
      platform_defaults.fetch(:state_user)
    end

    def default_state_group
      platform_defaults.fetch(:state_group)
    end

    def resolved_listen_addresses(listen, listen_network)
      return Array(listen).compact unless listen.nil?
      return [] if listen_network.nil?
      return [node['ipaddress']] if listen_network == 'primary' && node['ipaddress']

      network = IPAddr.new(listen_network)

      node.dig('network', 'interfaces').to_h.each_value do |interface|
        next unless interface['addresses']

        interface['addresses'].each do |ip, params|
          next unless %w(inet inet6).include?(params['family'])

          return [ip] if network.include?(IPAddr.new(ip))
        end
      end

      []
    end

    def sync_command(new_resource)
      if el9_plus?
        return "ntpd -q -u #{new_resource.state_user}"
      end

      source = new_resource.sync_clock_source || effective_servers(new_resource).first || Array(new_resource.pools).first
      raise Chef::Exceptions::ValidationFailed, 'sync_clock requires at least one server, pool, or explicit sync_clock_source.' if source.nil?

      "ntpdate -u #{source}"
    end

    def config_hash(new_resource)
      tinker = new_resource.tinker.dup
      if node['virtualization'] &&
         node['virtualization']['role'] == 'guest' &&
         new_resource.disable_tinker_panic_on_virtualization_guest
        tinker[:panic] = 0
      end

      {
        driftfile: new_resource.driftfile,
        statsdir: new_resource.statsdir,
        leapfile: new_resource.leapfile,
        logfile: new_resource.logfile,
        logconfig: new_resource.logconfig,
        statistics: new_resource.statistics,
        ignore: Array(new_resource.ignore).compact,
        listen: resolved_listen_addresses(new_resource.listen, new_resource.listen_network),
        peers: new_resource.peers.sort,
        servers: (effective_servers(new_resource) - new_resource.peers).sort,
        pools: new_resource.pools.sort,
        restrict_default: new_resource.restrict_default,
        restrictions: new_resource.restrictions,
        monitor: new_resource.monitor,
        localhost_noquery: new_resource.localhost.fetch(:noquery),
        orphan: new_resource.orphan,
        peer: new_resource.peer,
        server: new_resource.server,
        tinker: tinker,
        tos_maxdist: new_resource.tos.fetch(:maxdist),
        keys: new_resource.keys,
        trustedkey: new_resource.trustedkey,
        requestkey: new_resource.requestkey,
        dscp: new_resource.dscp,
        ipaddress: node['ipaddress'],
        fqdn: node['fqdn'],
      }
    end

    def effective_servers(new_resource)
      return [] if implicit_default_servers?(new_resource)

      Array(new_resource.servers)
    end

    private

    def implicit_default_servers?(new_resource)
      return false unless new_resource.respond_to?(:property_is_set?)
      return false if new_resource.property_is_set?(:servers)

      Array(new_resource.peers).any? || Array(new_resource.pools).any?
    end

    def el9_plus?
      return false unless node['platform_family'] == 'rhel'
      return false if node['platform'] == 'amazon'

      Gem::Requirement.new('>= 9').satisfied_by?(Gem::Version.new(node['platform_version']))
    end

    def platform_defaults
      return EL9_PLATFORM_DEFAULTS if el9_plus?

      DEB_NTPSEC_PLATFORM_DEFAULTS
    end
  end
end
