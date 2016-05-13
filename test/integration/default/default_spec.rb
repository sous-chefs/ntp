describe file('/etc/ntp.conf') do
  it { should be_file }
end

describe file('/etc/ntp.leapseconds') do
  it { should be_file }
end

describe command('pgrep ntp') do
  its('exit_status') { should eq 0 }
end
