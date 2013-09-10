require 'spec_helper'

describe "ntp::undo" do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new()
    runner.converge('recipe[ntp::undo]')
  end

  it "halts the ntp service" do
    expect(chef_run).to stop_service "ntp"
    expect(chef_run).to set_service_to_not_start_on_boot 'ntp'
  end

  it "Removes the ntp packages" do
    expect(chef_run).to remove_package "ntp"
    expect(chef_run).to remove_package "ntpdate"
  end

end
