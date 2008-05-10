require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'

module EasyOpen
  class OpenCallStack
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
      
      call_stack = nil
      open("#{Config[:call_stack_dump]}", "r") { |io|
        call_stack = Marshal.load(io)
      }
      
      node = call_stack.pop
      
      open("#{Config[:call_stack_dump]}", "w") { |mio|
        Marshal.dump(call_stack, mio)
      }
      return node
    end
  end
end