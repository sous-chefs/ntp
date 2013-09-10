require File.expand_path('../support/helpers', __FILE__)

describe 'ntp::ntpdate' do

  include Helpers::Ntp

  it 'Installs the ntpdate package' do
    skip unless ["debian"].include? node['platform_family']
    package("less").must_be_installed
  end

  it 'Creates the ntpdate conf file' do
    skip unless ["debian"].include? node['platform_family']

    if node['ntp']['ntpdate']['disable']
      file('/etc/default/ntpdate').must_include "exit 0"
    else
      file('/etc/default/ntpdate').wont_include "exit 0"
    end

    file('/etc/default/ntpdate').must_exist.with(
      :owner, node['ntp']['conf_owner']).and(
        :group, node['ntp']['conf_group'])
  end

end
