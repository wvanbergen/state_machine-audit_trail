require 'spec_helper_mongoid'

describe StateMachine::AuditTrail do
  
  it "should have a VERSION constant" do
    StateMachine::AuditTrail.const_defined?('VERSION').should be_true
  end
  
  context 'on an object with a single state machine' do
    let!(:state_machine) { TestModel.create! }
    
    it "should log an event with all fields set correctly" do
      state_machine.start!
      last_transition = TestModelStateTransition.where(:test_model_id => state_machine.id).last

      last_transition.event.to_s.should == 'start'
      last_transition.from.should == 'waiting'
      last_transition.to.should == 'started'
      last_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
    end
    
    it "should log multiple events" do
      lambda { state_machine.start && state_machine.stop && state_machine.start }.should change(TestModelStateTransition, :count).by(3)
    end
    
    it "should do nothing when the transition is not exectuted successfully" do
      lambda { state_machine.stop }.should_not change(TestModelStateTransition, :count)
    end
  end
  
  context 'on an object with multiple state machines' do
    let!(:state_machine) { TestModelWithMultipleStateMachines.create! }
    
    it "should log a state transition for the affected state machine" do
      lambda { state_machine.begin_first! }.should change(TestModelWithMultipleStateMachinesFirstTransition, :count).by(1)
    end

    it "should not log a state transition for the unaffected state machine" do
      lambda { state_machine.begin_first! }.should_not change(TestModelWithMultipleStateMachinesSecondTransition, :count)
    end
  end
  
  context 'on an object with a state machine having an initial state' do
    let(:state_machine_class) { TestModelWithMultipleStateMachines }
    let(:state_transition_class) { TestModelWithMultipleStateMachinesFirstTransition }
    
    it "should log a state transition for the inital state" do
      lambda { state_machine_class.create! }.should change(state_transition_class, :count).by(1)
    end
    
    it "should only set the :to state for the initial transition" do
      state_machine_class.create!
      initial_transition = state_transition_class.last
      initial_transition.event.should be_nil
      initial_transition.from.should be_nil
      initial_transition.to.should == 'beginning'
      initial_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
    end
  end
  
  context 'on an object with a state machine not having an initial state' do
    let(:state_machine_class) { TestModelWithMultipleStateMachines }
    let(:state_transition_class) { TestModelWithMultipleStateMachinesSecondTransition }
    
    it "should not log a transition when the object is created" do
      lambda { state_machine_class.create! }.should_not change(state_transition_class, :count)
    end

    it "should log a transition for the first event" do
      lambda { state_machine_class.create.begin_second! }.should change(state_transition_class, :count).by(1)
    end

    it "should not set a value for the :from state on the first transition" do
      state_machine_class.create.begin_second!
      first_transition = state_transition_class.last
      first_transition.event.to_s.should == 'begin_second'
      first_transition.from.should be_nil
      first_transition.to.should == 'beginning'
      first_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
    end
  end

  it "should properly grab the class name from STI models" do
    m = TestModelDescendant.create!
    lambda { m.start! }.should_not raise_error
  end
end
