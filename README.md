# NTP Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/ntp.svg)](https://supermarket.chef.io/cookbooks/ntp)
[![CI State](https://github.com/sous-chefs/ntp/workflows/ci/badge.svg)](https://github.com/sous-chefs/ntp/actions?query=workflow%3Aci)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

The `ntp` cookbook now provides a single custom resource, `ntp_service`, for
managing the distro-packaged NTP service on current Debian, Ubuntu, and
Enterprise Linux 9+ releases.

## Supported Platforms

- Debian 12+
- Enterprise Linux 9+
- Ubuntu 22.04+

Additional platform constraints are documented in
[LIMITATIONS.md](LIMITATIONS.md).

## Resource

### `ntp_service`

Use `ntp_service` to install the platform-appropriate NTP package, render the
packaged config file, and enable the packaged systemd service.

```ruby
ntp_service 'default' do
  servers %w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org)
end
```

See [documentation/ntp_ntp_service.md](documentation/ntp_ntp_service.md) for
the full property reference.

## Testing

```text
cookstyle
chef exec rspec
KITCHEN_LOCAL_YAML=kitchen.dokken.yml kitchen test default-ubuntu-2404 default-rockylinux-9 --destroy=always
```
