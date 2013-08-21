#!/usr/bin/env bats

@test "ntpd should be running" {
  /etc/init.d/ntpd status
}

@test "local time should be close to pool.ntp.org" {
  /usr/lib64/nagios/plugins/check_ntp_time -H 0.pool.ntp.org -w 0.5 -c 1
}
