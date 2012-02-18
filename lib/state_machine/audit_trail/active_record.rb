class StateMachine::AuditTrail::ActiveRecord < StateMachine::AuditTrail::Backend
  def log(object, event, from, to, timestamp = Time.now)
    # Let ActiveRecord manage the timestamp for us so it does the 
    # right thing with regards to timezones.
    transition_class.create(foreign_key_field(object) => object.id, :event => event, :from => from, :to => to)
  end

  def foreign_key_field(object)
    object.class.base_class.name.foreign_key.to_sym
  end
end

