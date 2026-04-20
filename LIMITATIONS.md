# Limitations

## Package Availability

This cookbook now targets Linux distributions that provide `ntpsec` from their
distribution package archives. It does not configure third-party repositories
automatically.

### APT (Debian/Ubuntu)

- Debian 12 (Bookworm): `ntpsec` is available from the Debian archive and
  installs `/etc/ntpsec/ntp.conf` plus the `ntpsec.service` systemd unit.
- Debian 13 (Trixie): `ntpsec` is available from the Debian archive and
  installs `/etc/ntpsec/ntp.conf` plus the `ntpsec.service` systemd unit.
- Ubuntu 22.04 (Jammy): `ntpsec` is available in the `universe` component.
  The legacy `ntp` and `ntpdate` package names are transitional or deprecated.
- Ubuntu 24.04 (Noble): `ntpsec` is available in the `universe` component.
  The legacy `ntp` and `ntpdate` package names are transitional packages that
  depend on `ntpsec` and `ntpsec-ntpdate`.

### DNF/YUM (RHEL family)

- Enterprise Linux 9+: `ntpsec` is expected to come from EPEL 9 or an
  equivalent repository. This cookbook supports the packaged service once that
  repository is already configured.
- Amazon Linux 2023: the published package list does not include `ntp` or
  `ntpsec`.

## Architecture Limitations

- Debian 12/13 package pages list `ntpsec` builds across multiple
  architectures, including `amd64`, `arm64`, and other release architectures.
- Ubuntu 22.04/24.04 package pages list `ntpsec` and `ntpsec-ntpdate` for
  `amd64`, `arm64`, `armhf`, `ppc64el`, `riscv64`, and `s390x`.
- This cookbook's CI only validates the platform images used by Test Kitchen,
  which are `amd64` Dokken images.

## Source/Compiled Installation

This cookbook does not build NTP from source. It manages the distro-packaged
`ntpsec` service and configuration only.

## Known Issues

- Ubuntu ships `ntpsec` in `universe`, so package availability follows Ubuntu's
  community-supported repository rather than the `main` archive.
- RHEL-family support requires repository management for EPEL or an equivalent
  source, which remains outside the scope of this cookbook.
- Amazon Linux 2023 is intentionally excluded because the base distribution does
  not publish a supported `ntp` or `ntpsec` package.
