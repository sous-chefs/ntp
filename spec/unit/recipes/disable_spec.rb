require 'spec_helper'

describe "ntp::disable" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new()
    runner.converge('recipe[ntp::disable]')
  end

  it "halts the ntp service" do
    expect(chef_run).to stop_service "ntp"
    expect(chef_run).to set_service_to_not_start_on_boot 'ntp'
  end

  context "Ubuntu" do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
      runner.converge('recipe[ntp::disable]')
    end

    it "Disables the /etc/default/ntpdate file" do
      file = chef_run.template('/etc/default/ntpdate')
      expect(file).to be_owned_by('root', 'root')
      expect(chef_run).to create_file_with_content '/etc/default/ntpdate', "exit 0"
    end
  end

end
