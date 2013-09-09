require 'spec_helper'
require 'helpers/active_record'

describe StateMachine::AuditTrail::Backend::ActiveRecord do

  it "should create an ActiveRecord backend" do
    backend = StateMachine::AuditTrail::Backend.create_for_transition_class(ActiveRecordTestModelStateTransition, ActiveRecordTestModel)
    backend.should be_instance_of(StateMachine::AuditTrail::Backend::ActiveRecord)
  end

  it "should create a has many association on the state machine owner" do
    backend = StateMachine::AuditTrail::Backend.create_for_transition_class(ActiveRecordTestModelStateTransition, ActiveRecordTestModel)
    ActiveRecordTestModel.reflect_on_association(:active_record_test_model_state_transitions).collection?.should be_true
  end

  context 'on an object with a single state machine' do
    let!(:state_machine) { ActiveRecordTestModel.create! }

    it "should log an event with all fields set correctly" do
      state_machine.start!
      last_transition = ActiveRecordTestModelStateTransition.where(:active_record_test_model_id => state_machine.id).last

      last_transition.event.to_s.should == 'start'
      last_transition.from_state.should == 'waiting'
      last_transition.to_state.should == 'started'
      #last_transition.context.should_not be_nil
      last_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
    end

    it "should log multiple events" do
      lambda { state_machine.start && state_machine.stop && state_machine.start }.should change(ActiveRecordTestModelStateTransition, :count).by(3)
    end

    it "should do nothing when the transition is not executed successfully" do
      lambda { state_machine.stop }.should_not change(ActiveRecordTestModelStateTransition, :count)
    end
  end

  context 'on an object with a single state machine that wants to log a single context' do
    before do
      backend = StateMachine::AuditTrail::Backend.create_for_transition_class(ActiveRecordTestModelWithContextStateTransition, ActiveRecordTestModelWithContext, :context)
    end

    let!(:state_machine) { ActiveRecordTestModelWithContext.create! }

    it "should log an event with all fields set correctly" do
      state_machine.start!
      last_transition = ActiveRecordTestModelWithContextStateTransition.where(:active_record_test_model_with_context_id => state_machine.id).last
      last_transition.context.should == state_machine.context
    end
  end

  context 'on an object with multiple state machines' do
    let!(:state_machine) { ActiveRecordTestModelWithMultipleStateMachines.create! }

    it "should log a state transition for the affected state machine" do
      lambda { state_machine.begin_first! }.should change(ActiveRecordTestModelWithMultipleStateMachinesFirstTransition, :count).by(1)
    end

    it "should not log a state transition for the unaffected state machine" do
      lambda { state_machine.begin_first! }.should_not change(ActiveRecordTestModelWithMultipleStateMachinesSecondTransition, :count)
    end
  end

  context 'on an object with a state machine having an initial state' do
    let(:state_machine_class) { ActiveRecordTestModelWithMultipleStateMachines }
    let(:state_transition_class) { ActiveRecordTestModelWithMultipleStateMachinesFirstTransition }

    it "should log a state transition for the inital state" do
      lambda { state_machine_class.create! }.should change(state_transition_class, :count).by(1)
    end

    it "should only set the :to state for the initial transition" do
      state_machine_class.create!
      initial_transition = state_transition_class.last
      initial_transition.event.should be_nil
      initial_transition.from_state.should be_nil
      initial_transition.to_state.should == 'beginning'
      initial_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
    end
  end

  context 'on an object with a state machine not having an initial state' do
    let(:state_machine_class) { ActiveRecordTestModelWithMultipleStateMachines }
    let(:state_transition_class) { ActiveRecordTestModelWithMultipleStateMachinesSecondTransition }

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
      first_transition.from_state.should be_nil
      first_transition.to_state.should == 'beginning_second'
      first_transition.created_at.should be_within(10.seconds).of(Time.now.utc)
    end
  end

  context 'on a class using STI' do
    it "should properly grab the class name from STI models" do
      m = ActiveRecordTestModelDescendant.create!
      lambda { m.start! }.should_not raise_error
    end
  end

  context 'on a class using STI with own state machine' do
    it "should properly grab the class name from STI models" do
      m = ActiveRecordTestModelDescendantWithOwnStateMachine.create!
      lambda { m.complete! }.should_not raise_error
    end
  end
end
