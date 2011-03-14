class StateMachine::AuditTrail::Base < Struct.new(:transition_class)
  def log(object, transition)
    raise NotImplemented, "Implement in a subclass."
  end
  
  def log_initial(object, initial_state)
    raise NotImplemented, "Implement in a subclass."
  end
end
