require 'state_machine'

module StateMachineLogger

  VERSION = "0.0.0"
  
  def self.setup
    StateMachine::Machine.send(:include, StateMachineLogger::Machine)
  end
end

require 'state_machine_logger/machine'

StateMachineLogger.setup
