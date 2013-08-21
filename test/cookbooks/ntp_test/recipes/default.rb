if platform_family?("rhel","fedora")
  include_recipe "yum::epel"
  package 'nagios-plugins-ntp'
elsif platform_family?("debian")
  package 'nagios-plugins'
end
