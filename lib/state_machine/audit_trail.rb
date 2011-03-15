require 'state_machine'

module StateMachine::AuditTrail
    
  VERSION = "0.0.1"
    
  def self.setup
    StateMachine::Machine.send(:include, StateMachine::AuditTrail::TransitionAuditing)
  end
  
  def self.create(transition_class)
    return ActiveRecord.new(transition_class) if transition_class < ::ActiveRecord::Base
    raise NotImplemented, "Only support for ActiveRecord is included at this time"
  end
end

require 'state_machine/audit_trail/transition_auditing'
require 'state_machine/audit_trail/auditor'
require 'state_machine/audit_trail/active_record'
require 'state_machine/audit_trail/railtie' if defined?(::Rails)
StateMachine::AuditTrail.setup
