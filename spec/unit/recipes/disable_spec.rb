## Comments make me happy, I guess

require 'spec_helper'

describe "ntp::disable" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(
      log_level: :error,
      cookbook_path: COOKBOOK_PATH
    )
    Chef::Config.force_logger true
    runner.converge('recipe[ntp::disable]')
  end

# Standard test set
  it "halts the ntp service" do
    expect(chef_run).to stop_service "ntp"
    expect(chef_run).to set_service_to_not_start_on_boot 'ntp'
  end

# TODO: Test for the template with a particular variable passed in

  # it "Creates the /etc/default/ntpdate file" do
  #   expect(chef_run).to create_file '/etc/default/ntpdate'
  #   file = chef_run.template('/etc/default/ntpdate')
  #   expect(file).to be_owned_by('root', 'root')
  # end

end
