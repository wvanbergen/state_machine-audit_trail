require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'active_record'
require 'state_machine/audit_trail'


### Setup test database

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Base.connection.create_table(:test_models) do |t|
  t.string :state
  t.timestamps
end

ActiveRecord::Base.connection.create_table(:test_model_with_multiple_state_machines) do |t|
  t.string :first
  t.string :second
  t.timestamps
end



def create_transition_table(owner_class, state)
  class_name = "#{owner_class.name}#{state.to_s.camelize}Transition"
  
  ActiveRecord::Base.connection.create_table(class_name.tableize) do |t|
    t.integer owner_class.name.foreign_key
    t.string :event
    t.string :from
    t.string :to
    t.datetime :created_at
  end
end


# We probably want to provide a generator for this model and the accompanying migration.
class TestModelStateTransition < ActiveRecord::Base
  belongs_to :test_model
end

class TestModelWithMultipleStateMachinesFirstTransition < ActiveRecord::Base
  belongs_to :test_model
end

class TestModelWithMultipleStateMachinesSecondTransition < ActiveRecord::Base
  belongs_to :test_model
end


class TestModel < ActiveRecord::Base

  state_machine :state, :initial => :waiting do # log initial state?
    log_transitions 

    event :start do
      transition [:waiting, :stopped] => :started
    end
    
    event :stop do
      transition :started => :stopped
    end
  end
end

class TestModelWithMultipleStateMachines < ActiveRecord::Base

  state_machine :first, :initial => :beginning do
    log_transitions 

    event :begin_first do
      transition :beginning => :end
    end
  end
  
  state_machine :second do
    log_transitions 

    event :begin_second do
      transition nil => :beginning
    end
  end
end

create_transition_table(TestModel, :state)  
create_transition_table(TestModelWithMultipleStateMachines, :first)  
create_transition_table(TestModelWithMultipleStateMachines, :second)  

RSpec.configure do |config|
end
