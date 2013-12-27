class StateMachine::AuditTrail::Backend::ActiveRecord < StateMachine::AuditTrail::Backend
  attr_accessor :context_to_log

  def initialize(transition_class, owner_class, context_to_log = nil)
    self.context_to_log = context_to_log
    @association = transition_class.to_s.tableize.split('/').last.to_sym
    super transition_class
    owner_class.has_many(@association, :class_name => transition_class.to_s) unless owner_class.reflect_on_association(@association)
  end

  def log(object, event, from, to, timestamp = Time.now)
    # Let ActiveRecord manage the timestamp for us so it does the 
    # right thing with regards to timezones.
    params = {:event => event ? event.to_s : nil, :from => from, :to => to}
    [context_to_log].flatten(1).each { |context| params[context] = object.send(context) } unless self.context_to_log.nil?

    if object.new_record?
      object.send(@association).build(params)
    else
      object.send(@association).create(params)
    end

    nil
  end
end
