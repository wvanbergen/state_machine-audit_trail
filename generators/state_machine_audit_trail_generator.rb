require 'rails_generator'

class StateMachineAuditTrailGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options = {})
    super
    @source_model, @state_attribute, @transition_model = runtime_args
    @state_attribute ||= 'state'
    @transition_model ||= ''
  end

  def manifest
    record do |m|
      attributes = [Rails::Generator::GeneratedAttribute.new(@source_model.tableize.singularize, :references),
                    Rails::Generator::GeneratedAttribute.new(:event, :string),
                    Rails::Generator::GeneratedAttribute.new(:from, :string),
                    Rails::Generator::GeneratedAttribute.new(:to, :string),
                    Rails::Generator::GeneratedAttribute.new(:created_at, :timestamp)]

      #Model file
      m.directory File.join('app/models', class_path)
      m.template 'model:model.rb', File.join('app/models', class_path, "#{transition_file_name}.rb"), :assigns => {:class_name => transition_class_name, :attributes => attributes}

      #Migration
      options[:skip_timestamps] = true
      migration_file_path = transition_file_name.gsub(/\//, '_')
      migration_name = transition_class_name
      if ActiveRecord::Base.pluralize_table_names
        migration_name = migration_name.pluralize
        migration_file_path = migration_file_path.pluralize
      end

      m.migration_template 'model:migration.rb', 'db/migrate', :assigns => {:migration_name => "Create#{migration_name.gsub(/::/, '')}",
                                                                            :table_name => transition_file_name.pluralize,
                                                                            :attributes => attributes},
                                                               :migration_file_name => "create_#{migration_file_path}"
    end
  end

  protected

  def transition_class_name
    @transition_model.blank? ? "#{@source_model.camelize}#{@state_attribute.camelize}Transition" : @transition_model
  end

  def transition_file_name
    @transition_model.blank? ? "#{@source_model.downcase}_#{@state_attribute}_transition" : @transition_model.tableize.singularize
  end
end