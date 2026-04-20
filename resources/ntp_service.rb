# frozen_string_literal: true

provides :ntp_service
unified_mode true
default_action :create

include NtpCookbook::Helpers

property :instance_name, String, name_property: true
property :package_name, String, default: lazy { default_package_name }, desired_state: false
property :sync_package_name, [String, nil], default: lazy { default_sync_package_name }, desired_state: false
property :service_name, String, default: lazy { default_service_name }, desired_state: false
property :config_path, String, default: lazy { default_config_path }
property :varlibdir, String, default: lazy { default_varlibdir }
property :statsdir, String, default: lazy { default_statsdir }
property :driftfile, String, default: lazy { default_driftfile }
property :leapfile, String, default: lazy { default_leapfile }
property :config_owner, String, default: 'root'
property :config_group, String, default: 'root'
property :state_user, String, default: lazy { default_state_user }
property :state_group, String, default: lazy { default_state_group }
property :servers, [String, Array], coerce: proc { |value| Array(value) }, default: lazy { default_servers }
property :peers, [String, Array], coerce: proc { |value| Array(value) }, default: []
property :pools, [String, Array], coerce: proc { |value| Array(value) }, default: []
property :restrictions, [String, Array], coerce: proc { |value| Array(value) }, default: []
property :ignore, [String, Array, nil], coerce: proc { |value| value.nil? ? nil : Array(value) }, default: nil
property :listen, [String, Array, nil], coerce: proc { |value| value.nil? ? nil : Array(value) }, default: nil
property :listen_network, [String, nil]
property :restrict_default, String, default: 'limited kod notrap nomodify nopeer noquery'
property :statistics, [true, false], default: true
property :monitor, [true, false], default: false
property :sync_clock, [true, false], default: false
property :sync_clock_source, [String, nil]
property :sync_hw_clock, [true, false], default: false
property :conf_restart_immediate, [true, false], default: false, desired_state: false
property :disable_tinker_panic_on_virtualization_guest, [true, false], default: true
property :peer, Hash, default: { key: nil, use_iburst: true, use_burst: false, minpoll: 6, maxpoll: 10 }
property :server, Hash, default: { prefer: '', use_iburst: true, use_burst: false, minpoll: 6, maxpoll: 10 }
property :tinker, Hash, default: { allan: 1500, dispersion: 15, panic: 1000, step: 0.128, stepout: 900 }
property :localhost, Hash, default: { noquery: false }
property :orphan, Hash, default: { enabled: false, stratum: 5 }
property :tos, Hash, default: { maxdist: 1 }
property :logfile, [String, nil]
property :logconfig, [String, nil], default: 'all'
property :keys, [String, nil]
property :trustedkey, [String, nil]
property :requestkey, [String, nil]
property :dscp, [Integer, nil], default: nil

action_class do
  include NtpCookbook::Helpers
end

action :create do
  assert_supported_platform!

  package new_resource.package_name do
    action :install
  end

  unless new_resource.sync_package_name.nil?
    package new_resource.sync_package_name do
      action :install
      only_if { new_resource.sync_clock }
    end
  end

  [new_resource.varlibdir, new_resource.statsdir].each do |path|
    directory path do
      owner new_resource.state_user
      group new_resource.state_group
      mode '0755'
      recursive true
    end
  end

  template new_resource.config_path do
    cookbook 'ntp'
    source 'ntp.conf.erb'
    owner new_resource.config_owner
    group new_resource.config_group
    mode '0644'
    variables(ntp_config: lazy { config_hash(new_resource) })
    notifies :restart, "service[#{new_resource.service_name}]", :immediately if new_resource.conf_restart_immediate
    notifies :restart, "service[#{new_resource.service_name}]" unless new_resource.conf_restart_immediate
  end

  if new_resource.sync_clock
    service new_resource.service_name do
      action :stop
    end

    execute 'sync system clock with ntp source' do
      command lazy { sync_command(new_resource) }
      action :run
    end
  end

  execute 'sync hardware clock with system clock' do
    command 'hwclock --systohc'
    action :run
    only_if { new_resource.sync_hw_clock }
  end

  service new_resource.service_name do
    supports status: true, restart: true
    action %i(enable start)
  end
end

action :start do
  service new_resource.service_name do
    action :start
  end
end

action :stop do
  service new_resource.service_name do
    action :stop
  end
end

action :restart do
  service new_resource.service_name do
    action :restart
  end
end

action :delete do
  assert_supported_platform!

  service new_resource.service_name do
    action %i(stop disable)
  end

  file new_resource.config_path do
    action :delete
  end

  directory new_resource.statsdir do
    recursive true
    action :delete
  end

  directory new_resource.varlibdir do
    recursive true
    action :delete
  end

  unless new_resource.sync_package_name.nil?
    package new_resource.sync_package_name do
      action :remove
    end
  end

  package new_resource.package_name do
    action :remove
  end
end
