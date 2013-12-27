require 'state_machine'

module StateMachine::AuditTrail
    
  def self.setup
    StateMachine::Machine.send(:include, StateMachine::AuditTrail::TransitionAuditing)
  end
end

require 'state_machine/audit_trail/version'
require 'state_machine/audit_trail/transition_auditing'
require 'state_machine/audit_trail/backend'
require 'state_machine/audit_trail/railtie' if defined?(::Rails) && Rails::VERSION::MAJOR >= 3

StateMachine::AuditTrail.setup
