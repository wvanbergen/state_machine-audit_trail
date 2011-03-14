class StateMachine::AuditTrail::ActiveRecord < StateMachine::AuditTrail::Base
  def log(object, transition)
    transition_class.create({
      foreign_key_field(object) => object.id, :event => transition.event, 
      :from => transition.from, :to => transition.to
    })
  end
  
  def log_initial(object, initial_state)
    transition_class.create({
      foreign_key_field(object) => object.id, :event => nil, 
      :from => nil, :to => initial_state
    })
  end
  
  def foreign_key_field(object)
    object.class.name.foreign_key
  end
end
