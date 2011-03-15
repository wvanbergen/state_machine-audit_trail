require 'spec_helper'

describe StateMachine::AuditTrail do
  it "should have a VERSION constant" do
    StateMachine::AuditTrail.const_defined?('VERSION').should be_true
  end
  
  it "should log an event with all fields set correctly" do
    m = TestModel.create!
    m.start!
    last_transition = TestModelStateTransition.where(:test_model_id => m.id).last

    last_transition.event.should == 'start'
    last_transition.from.should == 'waiting'
    last_transition.to.should == 'started'
    last_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
  end
  
  it "should log multiple events" do
    m = TestModel.create!

    lambda do
      m.start
      m.stop
      m.start
    end.should change(TestModelStateTransition, :count).by(3)
  end
  
  it "should do nothing when the transition is not exectuted successfully" do
    m = TestModel.create!
    lambda { m.stop }.should_not change(TestModelStateTransition, :count)
  end
  
  it "should log a state_machine specific event for the affected state machine" do
    m = TestModelWithMultipleStateMachines.create!
    lambda { m.begin_first! }.should change(TestModelWithMultipleStateMachinesFirstTransition, :count).by(1)
  end

  it "should not log a state_machine specific event for the unaffected state machine" do
    m = TestModelWithMultipleStateMachines.create!
    lambda { m.begin_first! }.should_not change(TestModelWithMultipleStateMachinesSecondTransition, :count)
  end
  
  it "should log a transition for the inital state" do
    lambda { TestModelWithMultipleStateMachines.create! }.should change(TestModelWithMultipleStateMachinesFirstTransition, :count).by(1)
  end
  
  it "should only log the :to state for an initial state" do
    TestModelWithMultipleStateMachines.create!
    initial_transition = TestModelWithMultipleStateMachinesFirstTransition.last
    initial_transition.event.should be_nil
    initial_transition.from.should be_nil
    initial_transition.to.should == 'beginning'
    initial_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
  end
  
  it "should not log a transition when the state machine does not have an initial state" do
    lambda { TestModelWithMultipleStateMachines.create! }.should_not change(TestModelWithMultipleStateMachinesSecondTransition, :count)
  end
  
  it "should create a transiction for the first record when the state machine does not have an initial state" do
    m = TestModelWithMultipleStateMachines.create!
    lambda { m.begin_second! }.should change(TestModelWithMultipleStateMachinesSecondTransition, :count).by(1)
  end
  
  it "should not have a value for the from state when the state machine does not have an initial state" do
    m = TestModelWithMultipleStateMachines.create!
    m.begin_second!
    first_transition = TestModelWithMultipleStateMachinesSecondTransition.last
    first_transition.event.should == 'begin_second'
    first_transition.from.should be_nil
    first_transition.to.should == 'beginning'
    first_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
  end
end
