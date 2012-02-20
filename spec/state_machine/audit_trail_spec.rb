require 'spec_helper'

describe StateMachine::AuditTrail do
  
  it "should have a VERSION constant" do
    StateMachine::AuditTrail.const_defined?('VERSION').should be_true
  end
  
  it "should include the auditing module into StateMachine::Machine" do
    StateMachine::Machine.included_modules.should include(StateMachine::AuditTrail::TransitionAuditing)
  end
end
