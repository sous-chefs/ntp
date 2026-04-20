# ntp_ntp_service

Installs the platform-appropriate distro-packaged NTP daemon, renders the
packaged config file, and manages the packaged systemd service.

## Actions

| Action | Description |
|---|---|
| `:create` | Installs and configures the platform NTP service and starts it (default) |
| `:start` | Starts the platform NTP service |
| `:stop` | Stops the platform NTP service |
| `:restart` | Restarts the platform NTP service |
| `:delete` | Stops the service, removes the managed config, and removes the packages |

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `instance_name` | String | `name property` | Resource instance name |
| `package_name` | String | platform default | Main package to install |
| `sync_package_name` | `String`, `nil` | platform default | Optional package used for `sync_clock` when the platform requires one |
| `service_name` | String | platform default | Systemd service name |
| `config_path` | String | platform default | Path to the generated config file |
| `varlibdir` | String | platform default | State directory for drift data |
| `statsdir` | String | platform default | Statistics directory |
| `driftfile` | String | platform default | Drift file path |
| `leapfile` | String | platform default | Leap seconds file path |
| `config_owner` | String | `'root'` | Owner of the rendered config |
| `config_group` | String | `'root'` | Group of the rendered config |
| `state_user` | String | platform default | Owner for state and stats directories |
| `state_group` | String | platform default | Group for state and stats directories |
| `servers` | `String`, `Array` | `['0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org']` | Upstream NTP servers |
| `peers` | `String`, `Array` | `[]` | Peer hosts to configure |
| `pools` | `String`, `Array` | `[]` | Upstream NTP pools |
| `restrictions` | `String`, `Array` | `[]` | Extra `restrict` lines |
| `ignore` | `String`, `Array`, `nil` | `nil` | Interfaces to ignore |
| `listen` | `String`, `Array`, `nil` | `nil` | Explicit listen addresses |
| `listen_network` | `String`, `nil` | `nil` | Network CIDR or `'primary'` used to derive a listen address |
| `restrict_default` | String | `'limited kod notrap nomodify nopeer noquery'` | Default `restrict` policy |
| `statistics` | Boolean | `true` | Enables loop, peer, and clock statistics |
| `monitor` | Boolean | `false` | Enables or disables monitor support |
| `sync_clock` | Boolean | `false` | Runs a one-time platform-appropriate clock sync during convergence |
| `sync_clock_source` | `String`, `nil` | `nil` | Explicit source used for `sync_clock` on platforms that use `ntpdate` |
| `sync_hw_clock` | Boolean | `false` | Runs `hwclock --systohc` after convergence |
| `conf_restart_immediate` | Boolean | `false` | Restarts the service immediately on config changes |
| `disable_tinker_panic_on_virtualization_guest` | Boolean | `true` | Forces `tinker panic 0` for guests |
| `peer` | Hash | `{ key: nil, use_iburst: true, use_burst: false, minpoll: 6, maxpoll: 10 }` | Peer tuning values |
| `server` | Hash | `{ prefer: '', use_iburst: true, use_burst: false, minpoll: 6, maxpoll: 10 }` | Server and pool tuning values |
| `tinker` | Hash | `{ allan: 1500, dispersion: 15, panic: 1000, step: 0.128, stepout: 900 }` | `tinker` configuration |
| `localhost` | Hash | `{ noquery: false }` | Localhost `restrict` settings |
| `orphan` | Hash | `{ enabled: false, stratum: 5 }` | Orphan mode settings |
| `tos` | Hash | `{ maxdist: 1 }` | `tos` settings |
| `logfile` | `String`, `nil` | `nil` | Optional log file path |
| `logconfig` | `String`, `nil` | `'all'` | `logconfig` value |
| `keys` | `String`, `nil` | `nil` | Optional key file path |
| `trustedkey` | `String`, `nil` | `nil` | Optional trusted key value |
| `requestkey` | `String`, `nil` | `nil` | Optional request key value |
| `dscp` | `Integer`, `nil` | `nil` | Optional DSCP value |

## Examples

Platform defaults:

- Debian 12+ and Ubuntu 22.04+ use `ntpsec`, `/etc/ntpsec/ntp.conf`, and the `ntpsec` service.
- Enterprise Linux 9+ uses `ntpsec`, `/etc/ntp.conf`, and the `ntpd` service. EPEL must already be enabled.

### Basic usage

```ruby
ntp_service 'default'
```

### Configure custom upstream servers

```ruby
ntp_service 'default' do
  servers %w(time1.example.com time2.example.com)
  pools []
  restrict_default 'kod nomodify nopeer noquery'
end
```
