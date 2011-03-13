require 'spec_helper'

describe StateMachineLogger do
  it "should have a VERSION constant" do
    StateMachineLogger.const_defined?('VERSION').should be_true
  end
end
