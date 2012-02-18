# This is the class that does the actual logging.
# We need one of these per ORM

class StateMachine::AuditTrail::Mongoid < StateMachine::AuditTrail::Backend

  # Public writes the log to the database
  #
  # object: the object being watched by the state_machine observer
  # event:  the event being observed by the state machine
  # from:   the state of the object prior to the event
  # to:     the state of the object after the event
  def log(object, event, from, to, timestamp = Time.now)
    tc = transition_class
    foreign_key_field = tc.relations.keys.first
    transition_class.create(foreign_key_field => object, :event => event, :from => from, :to => to, :create_at => timestamp)
  end


end
