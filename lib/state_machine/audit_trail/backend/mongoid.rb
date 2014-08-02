# This is the class that does the actual logging.
# We need one of these per ORM

class StateMachine::AuditTrail::Backend::Mongoid < StateMachine::AuditTrail::Backend

  # Public writes the log to the database
  #
  # object: the object being watched by the state_machine observer
  # transition: state machine transition object that state machine passes to after/before transition callbacks
  def log(object, transition, timestamp = Time.now)
    tc = transition_class
    foreign_key_field = tc.relations.keys.first
    transition_class.create(foreign_key_field => object, :event => transition.event, :from => transition.from, :to => transition.to, :created_at => timestamp)
  end


end
