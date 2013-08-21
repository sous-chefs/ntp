#!/usr/bin/env bats

@test "ntpd should be running" {
  service ntp status
}

@test "local time should be close to pool.ntp.org" {
  /usr/lib/nagios/plugins/check_ntp_time -H 0.pool.ntp.org -w 0.5 -c 1
}
