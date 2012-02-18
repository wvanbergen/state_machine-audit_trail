require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'mongoid'
require 'rspec'
require 'state_machine/audit_trail'


### Setup test database

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("sm_audit_trail")
end



# We probably want to provide a generator for this model and the accompanying migration.
class TestModelStateTransition
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :test_model
end

class TestModelWithMultipleStateMachinesFirstTransition
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :test_model
end

class TestModelWithMultipleStateMachinesSecondTransition
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :test_model
end

class TestModel
  
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

class TestModelDescendant < TestModel
  include Mongoid::Timestamps
end

class TestModelWithMultipleStateMachines
  
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
      transition nil => :beginning
    end
  end
end


RSpec.configure do |config|
end
