 require 'ostruct'
# this class inserts the appropriate hooks into the state machine.
# it also contains functions to instantiate an object of the "transition_class"
# the transition_class is the class for the model which holds the audit_trail

module StateMachine::AuditTrail::TransitionAuditing
  attr_accessor :transition_class_name

  # Public tells the state machine to hook in the appropriate before / after behaviour
  #
  # options: a Hash of options. keys that are used are :to => CustomTransitionClass,
  #   :context_to_log => method(s) to call on object and store in transitions
  def store_audit_trail(options = {})
    state_machine = self
    state_machine.transition_class_name = (options[:to] || default_transition_class_name).to_s
    state_machine.setup_backend(options[:context_to_log])

    state_machine.after_transition do |object, transition|
      state_machine.backend.log(object, transition)
    end

    unless state_machine.action == nil
      state_machine.owner_class.after_create do |object|
        if !object.send(state_machine.attribute).nil?
          state_machine.backend.log(object, OpenStruct.new(:to => object.send(state_machine.attribute)))
        end
      end
    end
  end

  def setup_backend(context_to_log = nil)
    @backend = StateMachine::AuditTrail::Backend.create_for_transition_class(transition_class, self.owner_class, context_to_log)
  end

  # Public returns an instance of the class which does the actual audit trail logging
  def backend
    @backend
  end

  private

  def transition_class
    @transition_class ||= transition_class_name.constantize
  end

  def default_transition_class_name
    owner_class_or_base_class = owner_class.respond_to?(:base_class) ? owner_class.base_class : owner_class
    "#{owner_class_or_base_class.name}#{attribute.to_s.camelize}Transition"
  end
end
