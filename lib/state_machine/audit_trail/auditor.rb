class StateMachine::AuditTrail::Auditor < Struct.new(:transition_class)
  def log(object, event, from, to, timestamp = Time.now)
    raise NotImplemented, "Implement in a subclass."
  end
end
