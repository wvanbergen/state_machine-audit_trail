require 'spec_helper'

describe StateMachineLogger do
  it "should have a VERSION constant" do
    StateMachineLogger.const_defined?('VERSION').should be_true
  end
  
  it "should log an event with all fields set correctly" do
    m = TestModel.create!
    m.start
    last_transaction = TestModelStateTransition.where(:test_model_id => m.id).last

    last_transaction.event.should == 'start'
    last_transaction.from.should == 'waiting'
    last_transaction.to.should == 'started'
    last_transaction.timestamp.should be_within(10.seconds).of(Time.now.utc)
  end
  
  it "should log multiple events" do
    lambda do
      m = TestModel.create!
      m.start
      m.stop
      m.start
    end.should change(TestModelStateTransition, :count).by(3)
  end
  
  it "should do nothing when the transition is not exectuted successfully" do
    lambda { TestModel.create.stop }.should_not change(TestModelStateTransition, :count)
  end
end
