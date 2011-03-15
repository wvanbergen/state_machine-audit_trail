module StateMachine::AuditTrail::TransitionLogging
  attr_accessor :transition_class_name

  def log_transitions(options = {})
    state_machine = self
    state_machine.transition_class_name = (options[:to] || default_transition_class_name).to_s

    state_machine.after_transition do |object, transition|
      state_machine.audit_trail.log(object, transition.event, transition.from, transition.to)
    end

    state_machine.owner_class.after_create do |object|
      if !object.send(state_machine.attribute).nil?
        state_machine.audit_trail.log(object, nil, nil, object.send(state_machine.attribute))
      end
    end
  end

  def audit_trail
    @transition_logger ||= StateMachine::AuditTrail.create(transition_class)
  end

  private

  def transition_class
    @transition_class ||= transition_class_name.constantize
  end

  def default_transition_class_name
    "#{owner_class.name}#{attribute.to_s.camelize}Transition"
  end
end
