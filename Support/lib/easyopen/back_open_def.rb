require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

module EasyOpen
  class BackOpenDef
    include EasyOpen::UI
    def initialize(config = {})
      Config.setup(config)
    end
    
    def run
      node = pop_call_stack
      if node
        open_menu(node)
      else
        puts "stack is empty"
      end
    end
    
    def pop_call_stack
      call_stack = CallStackRepository.load
      node = call_stack.pop
      CallStackRepository.save call_stack
      return node
    end
  end
end