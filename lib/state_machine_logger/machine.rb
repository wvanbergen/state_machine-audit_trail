module StateMachineLogger
  module Machine
    
    attr_accessor :transaction_class_name
    
    def log_transitions(options = {})
      self.transaction_class_name = (options[:to] || default_transition_class_name).to_s
      
      self.send(:after_transition) do |object, transaction|
        transition_class.create({
          foreign_key_field => object.id, :timestamp => Time.now.utc,
          :event => transaction.event, :from => transaction.from, :to => transaction.to
        })
      end
    end
    
    private
    
    def foreign_key_field
      owner_class.name.foreign_key
    end
    
    def default_transition_class_name
      "#{owner_class.name}#{attribute.to_s.camelize}Transition"
    end
    
    def transition_class
      @transition_class ||= transaction_class_name.constantize
    end
  end
end
