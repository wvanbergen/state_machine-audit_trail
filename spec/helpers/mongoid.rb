require 'mongoid'

### Setup test database

Mongoid.configure do |config|
  config.connect_to("sm_audit_trail")
end



# We probably want to provide a generator for this model and the accompanying migration.
class MongoidTestModelStateTransition
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :mongoid_test_model
end

class MongoidTestModelWithMultipleStateMachinesFirstTransition
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :mongoid_test_model
end

class MongoidTestModelWithMultipleStateMachinesSecondTransition
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :mongoid_test_model
end

class MongoidTestModel

  include Mongoid::Document
  include Mongoid::Timestamps

  state_machine :state, :initial => :waiting do # log initial state?
    store_audit_trail :orm => :mongoid

    event :start do
      transition [:waiting, :stopped] => :started
    end

    event :stop do
      transition :started => :stopped
    end
  end
end

class MongoidTestModelDescendant < MongoidTestModel
  include Mongoid::Timestamps
end

class MongoidTestModelWithMultipleStateMachines

  include Mongoid::Document
  include Mongoid::Timestamps

  state_machine :first, :initial => :beginning do
    store_audit_trail

    event :begin_first do
      transition :beginning => :end
    end
  end

  state_machine :second do
    store_audit_trail

    event :begin_second do
      transition nil => :beginning_second
    end
  end
end
