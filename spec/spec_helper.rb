require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'active_record'
require 'state_machine_logger'


### Setup test database

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Base.connection.create_table(:test_models) do |t|
  t.string :state
  t.timestamps
end

# We probably want to provide a generator for this migration and the accompanying model.
ActiveRecord::Base.connection.create_table(:test_model_state_transitions) do |t|
  t.integer :test_model_id
  t.string :event
  t.string :from
  t.string :to
  t.datetime :timestamp
end


class TestModel < ActiveRecord::Base

  state_machine :state, :initial => :waiting do # log initial state?
    
    # Enable logging
    log_transitions 
    
    # # The transition log class name is guessed to be model_name + state_attribute + 'Transition'.
    # # If not, provide the class name yourself using to :to-option:
    # log_transitions :to => 'TestModelStateTransition'
        
    event :start do
      transition [:waiting, :stopped] => :started
    end
    
    event :stop do
      transition :started => :stopped
    end
  end
end

# We probably want to provide a generator for this model and the accompanying migration.
class TestModelStateTransition < ActiveRecord::Base
  belongs_to :test_model
end


RSpec.configure do |config|
end
