require 'active_record'

### Setup test database

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Base.connection.create_table(:active_record_test_models) do |t|
  t.string :state
  t.string :type
  t.timestamps
end

ActiveRecord::Base.connection.create_table(:active_record_test_model_with_contexts) do |t|
  t.string :state
  t.string :type
  t.timestamps
end

ActiveRecord::Base.connection.create_table(:active_record_test_model_with_multiple_contexts) do |t|
  t.string :state
  t.string :type
  t.timestamps
end

ActiveRecord::Base.connection.create_table(:active_record_test_model_with_multiple_state_machines) do |t|
  t.string :first
  t.string :second
  t.timestamps
end

# We probably want to provide a generator for this model and the accompanying migration.
class ActiveRecordTestModelStateTransition < ActiveRecord::Base
  belongs_to :test_model
end

class ActiveRecordTestModelWithContextStateTransition < ActiveRecord::Base
  belongs_to :test_model
end

class ActiveRecordTestModelWithMultipleContextStateTransition < ActiveRecord::Base
  belongs_to :test_model
end

class ActiveRecordTestModelWithMultipleStateMachinesFirstTransition < ActiveRecord::Base
  belongs_to :test_model
end

class ActiveRecordTestModelWithMultipleStateMachinesSecondTransition < ActiveRecord::Base
  belongs_to :test_model
end

class ActiveRecordTestModelWithMultipleStateMachinesThirdTransition < ActiveRecord::Base
  belongs_to :test_model
end

class ActiveRecordTestModel < ActiveRecord::Base

  state_machine :state, :initial => :waiting do # log initial state?
    store_audit_trail

    event :start do
      transition [:waiting, :stopped] => :started
    end

    event :stop do
      transition :started => :stopped
    end
  end
end

class ActiveRecordTestModelWithContext < ActiveRecord::Base
  state_machine :state, :initial => :waiting do # log initial state?
    store_audit_trail :context_to_log => :context

    event :start do
      transition [:waiting, :stopped] => :started
    end

    event :stop do
      transition :started => :stopped
    end
  end

  def context
    "Some context"
  end
end

class ActiveRecordTestModelWithMultipleContext < ActiveRecord::Base
  state_machine :state, :initial => :waiting do # log initial state?
    store_audit_trail :context_to_log => [:context, :second_context]

    event :start do
      transition [:waiting, :stopped] => :started
    end

    event :stop do
      transition :started => :stopped
    end
  end

  def context
    "Some context"
  end

  def second_context
    "Extra context"
  end
end

class ActiveRecordTestModelDescendant < ActiveRecordTestModel
end

class ActiveRecordTestModelDescendantWithOwnStateMachine < ActiveRecordTestModel
  state_machine :state, :initial => :new do
    store_audit_trail

    event :complete do
      transition [:new] => :completed
    end
  end
end

class ActiveRecordTestModelWithMultipleStateMachines < ActiveRecord::Base

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

  state_machine :third, :action => nil do
    store_audit_trail

    event :begin_third do
      transition nil => :beginning_third
    end

    event :end_third do
      transition :beginning_third => :done_third
    end
  end
end

module SomeNamespace
  class ActiveRecordTestModelStateTransition < ActiveRecord::Base
    belongs_to :test_model
  end

  class ActiveRecordTestModel < ActiveRecord::Base

    state_machine :state, :initial => :waiting do # log initial state?
      store_audit_trail

      event :start do
        transition [:waiting, :stopped] => :started
      end

      event :stop do
        transition :started => :stopped
      end
    end
  end
end

def create_transition_table(owner_class, state, add_context = false)
  class_name = "#{owner_class.name}#{state.to_s.camelize}Transition"
  ActiveRecord::Base.connection.create_table(class_name.tableize) do |t|
    t.integer owner_class.name.foreign_key
    t.string :event
    t.string :from
    t.string :to
    t.string :context if add_context
    t.string :second_context if add_context
    t.datetime :created_at
  end
end

create_transition_table(ActiveRecordTestModel, :state)
create_transition_table(ActiveRecordTestModelWithContext, :state, true)
create_transition_table(ActiveRecordTestModelWithMultipleContext, :state, true)
create_transition_table(ActiveRecordTestModelWithMultipleStateMachines, :first)
create_transition_table(ActiveRecordTestModelWithMultipleStateMachines, :second)
create_transition_table(ActiveRecordTestModelWithMultipleStateMachines, :third)
