require 'state_machine'

module StateMachine::AuditTrail
    
  VERSION = "0.0.5"
    
  def self.setup
    StateMachine::Machine.send(:include, StateMachine::AuditTrail::TransitionAuditing)
  end
  
  # Public creates an instance of the class which does the actual logging
  #
  # transition_class: the Class which holds the audit trail
  #
  # in order to adda new ORM here, copy audit_trail/mongoid.rb to whatever you want to call the new file and implement the #log function there
  # then, return from here the appropriate object based on which ORM the transition_class is using
  def self.create_audit_trail_logger(transition_class)
    return ActiveRecord.new(transition_class) if transition_class < ::ActiveRecord::Base                     # for ActiveRecord
    return Mongoid.new(transition_class) if transition_class.included_modules.include?(::Mongoid::Document)  # for Mongoid
    raise NotImplemented, "Only support for ActiveRecord and Mongoid is included at this time"
  end
end

require 'state_machine/audit_trail/transition_auditing'
require 'state_machine/audit_trail/backend'
require 'state_machine/audit_trail/railtie' if defined?(::Rails)
StateMachine::AuditTrail.setup
