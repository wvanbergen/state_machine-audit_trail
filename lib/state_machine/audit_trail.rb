require 'state_machine'

module StateMachine::AuditTrail
    
  VERSION = "0.0.5"
    
  def self.setup
    StateMachine::Machine.send(:include, StateMachine::AuditTrail::TransitionAuditing)
  end
end

require 'state_machine/audit_trail/transition_auditing'
require 'state_machine/audit_trail/backend'
require 'state_machine/audit_trail/railtie' if defined?(::Rails)

StateMachine::AuditTrail.setup
