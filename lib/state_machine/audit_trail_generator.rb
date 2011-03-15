require 'rails/generators'

class StateMachine::AuditTrailGenerator < ::Rails::Generators::Base
  
  source_root File.join(File.dirname(__FILE__), 'templates')
  
  argument :source_model
  argument :state_attribute, :default => 'state'
  argument :transition_model, :default => nil


  def create_model
    Rails::Generators.invoke('model', [transition_class_name, "#{source_model.tableize}:references", "event:string", "from:string", "to:string", "created_at:timestamp", '--no-timestamps'])
  end
  
  protected
  
  def transition_class_name
    transition_model || "#{source_model.camelize}#{state_attribute.camelize}Transition"
  end
end
