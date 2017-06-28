config = if os.windows?
           'C:\NTP\etc\ntp.conf'
         else
           '/etc/ntp.conf'
         end

describe file(config) do
  it { should be_file }
end

if os.windows?
  describe service('NTP') do
    it { should be_running }
  end
else
  describe file('/etc/ntp.leapseconds') do
    it { should be_file }
  end

  describe command('pgrep ntp') do
    its('exit_status') { should eq 0 }
  end
end
