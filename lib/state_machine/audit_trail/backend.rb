class StateMachine::AuditTrail::Backend < Struct.new(:transition_class)
  def log(object, event, from, to, timestamp = Time.now)
    raise NotImplemented, "Implement in a subclass."
  end
end

require 'state_machine/audit_trail/active_record'
require 'state_machine/audit_trail/mongoid'
