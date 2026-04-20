# frozen_string_literal: true

require 'ipaddr'

module NtpCookbook
  module Helpers
    SUPPORTED_PLATFORMS = {
      'debian' => Gem::Requirement.new('>= 12'),
      'ubuntu' => Gem::Requirement.new('>= 22.04'),
    }.freeze

    def supported_platform?
      requirement = SUPPORTED_PLATFORMS[node['platform']]
      return false unless requirement

      requirement.satisfied_by?(Gem::Version.new(node['platform_version']))
    end

    def assert_supported_platform!
      return if supported_platform?

      raise Chef::Exceptions::UnsupportedPlatform,
            "ntp_service supports Debian 12+ and Ubuntu 22.04+. Found #{node['platform']} #{node['platform_version']}."
    end

    def default_servers
      %w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org)
    end

    def default_package_name
      'ntpsec'
    end

    def default_sync_package_name
      'ntpsec-ntpdate'
    end

    def default_service_name
      'ntpsec'
    end

    def default_config_path
      '/etc/ntpsec/ntp.conf'
    end

    def default_varlibdir
      '/var/lib/ntpsec'
    end

    def default_statsdir
      '/var/log/ntpsec'
    end

    def default_driftfile
      "#{default_varlibdir}/ntp.drift"
    end

    def default_leapfile
      '/usr/share/zoneinfo/leap-seconds.list'
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
      source = new_resource.sync_clock_source || new_resource.servers.first || new_resource.pools.first
      raise Chef::Exceptions::ValidationFailed, 'sync_clock requires at least one server, pool, or explicit sync_clock_source.' unless source

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
        servers: (new_resource.servers - new_resource.peers).sort,
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
  end
end
