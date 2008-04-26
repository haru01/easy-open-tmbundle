require File.dirname(__FILE__) + '/ui'

module EasyOpen
  class OpenCallStack
    include EasyOpen::UI
    def initialize(call_stack_dump = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}/call_stack.dump")
      @call_stack_dump = call_stack_dump
    end
    
    def run
      node = pop_call_stack
      if node
        open_menu([node])
      else
        puts "stack is empty"
      end
    end
    
    def pop_call_stack
      
      call_stack = nil
      open("#{@call_stack_dump}", "r") { |io|
        call_stack = Marshal.load(io)
      }
      
      node = call_stack.pop
      
      open("#{@call_stack_dump}", "w") { |mio|
        Marshal.dump(call_stack, mio)
      }
      return node
    end
  end
end