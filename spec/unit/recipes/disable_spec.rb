require 'spec_helper'

describe "ntp::disable" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(
      log_level: :error,
    )
    Chef::Config.force_logger true
    runner.converge('recipe[ntp::disable]')
  end

# Standard test set
  it "halts the ntp service" do
    expect(chef_run).to stop_service "ntp"
    expect(chef_run).to set_service_to_not_start_on_boot 'ntp'
  end

  pending "TODO: Fix the content match test" do
    it "Creates the /etc/default/ntpdate file" do
      # TODO: Fix this match so it actually works
      (chef_run).to create_file_with_content '/etc/default/ntpdate', "exit 0"
      file = chef_run.template('/etc/default/ntpdate')
      expect(file).to be_owned_by('root', 'root')
    end
  end

end
