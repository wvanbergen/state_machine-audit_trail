require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'active_record'
require 'state_machine_logger'

class TestModelStateTransition < ActiveRecord::Base
  belongs_to :test_model
end

class TestModel < ActiveRecord::Base

  state_machine :state, :initial => :waiting do
    
    log_transitions 
    
    event :start do
      transition [:waiting, :stopped] => :started
    end
    
    event :stop do
      transition :started => :stopped
    end
  end
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Base.connection.create_table(:test_models) do |t|
  t.string :state
  t.timestamps
end

ActiveRecord::Base.connection.create_table(:test_model_state_transitions) do |t|
  t.integer :test_model_id
  t.string :event
  t.string :from
  t.string :to
  t.datetime :timestamp
end

RSpec.configure do |config|
end
