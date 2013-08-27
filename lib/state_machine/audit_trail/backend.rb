class StateMachine::AuditTrail::Backend < Struct.new(:transition_class, :owner_class)

  autoload :Mongoid,      'state_machine/audit_trail/backend/mongoid'
  autoload :ActiveRecord, 'state_machine/audit_trail/backend/active_record'

  def log(object, event, from, to, timestamp = Time.now)
    raise NotImplemented, "Implement in a subclass."
  end
  
  # Public creates an instance of the class which does the actual logging
  #
  # transition_class: the Class which holds the audit trail
  #
  # in order to adda new ORM here, copy audit_trail/mongoid.rb to whatever you want to call the new file and implement the #log function there
  # then, return from here the appropriate object based on which ORM the transition_class is using  
  def self.create_for_transition_class(transition_class, owner_class, context_to_log = nil)
    if Object.const_defined?('ActiveRecord') && transition_class.ancestors.include?(::ActiveRecord::Base)
      return StateMachine::AuditTrail::Backend::ActiveRecord.new(transition_class, owner_class, context_to_log)
    elsif Object.const_defined?('Mongoid') && transition_class.ancestors.include?(::Mongoid::Document)
      # Mongoid implementation doesn't yet support additional context fields
      raise NotImplemented, "Mongoid does not support additional context fields" if context_to_log.present?

      return StateMachine::AuditTrail::Backend::Mongoid.new(transition_class, owner_class)
    else
      raise NotImplemented, "Only support for ActiveRecord and Mongoid is included at this time"
    end
  end
end
