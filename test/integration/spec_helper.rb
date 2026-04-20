# frozen_string_literal: true

def ntp_config_path
  os.redhat? ? '/etc/ntp.conf' : '/etc/ntpsec/ntp.conf'
end

def ntp_service_name
  os.redhat? ? 'ntpd' : 'ntpsec'
end

def ntp_package_name
  'ntpsec'
end
