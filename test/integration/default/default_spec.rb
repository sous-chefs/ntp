service_name =
  case os.family
  when 'redhat', 'suse', 'fedora'
    'ntpd'
  else
    'ntp'
  end

if (os.family == 'redhat' && os.release.to_i >= 8) || (inspec.os.name == 'fedora' && os.release.to_i >= 34)
  describe file '/etc/ntp.conf' do
    it { should_not be_file }
  end

  describe file '/etc/ntp.leapseconds' do
    it { should_not be_file }
  end

  describe service 'ntpd' do
    it { should_not be_enabled }
    it { should_not be_running }
  end
elsif os.family == 'redhat' && os.release.to_i < 8
  describe file '/usr/share/zoneinfo/leapseconds' do
    it { should be_file }
  end
elsif os.family == 'debian'
  describe file '/etc/ntp.conf' do
    it { should be_file }
  end

  describe ntp_conf do
    its('tos') { should eq 'maxdist 1' }
  end

  describe file '/usr/share/zoneinfo/leap-seconds.list' do
    it { should be_file }
  end

  describe service service_name do
    it { should be_enabled }
    it { should be_running }
  end

elsif os.windows?
  describe file 'C:\NTP\etc\ntp.conf' do
    it { should be_file }
  end

  describe service 'NTP' do
    it { should be_enabled }
    it { should be_running }
  end
elsif os.darwin?
  describe command 'sudo systemsetup -getnetworktimeserver' do
    its('stdout') { should match /0\.pool\.ntp\.org/ }
  end

  describe command 'sudo systemsetup -getusingnetworktime' do
    its('stdout') { should match /Network Time: On/ }
  end
else
  describe file '/etc/ntp.conf' do
    it { should be_file }
  end

  describe ntp_conf do
    its('tos') { should eq 'maxdist 1' }
  end

  describe file '/etc/ntp.leapseconds' do
    it { should be_file }
  end

  describe service service_name do
    it { should be_enabled }
    it { should be_running }
  end
end
