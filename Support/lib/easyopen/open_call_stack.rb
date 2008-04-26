require File.dirname(__FILE__) + '/ui'
require "yaml"

module EasyOpen
  class OpenCallStack
    include EasyOpen::UI
    def initialize(call_stack_yaml = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}/call_stack.yaml")
      @call_stack_yaml = call_stack_yaml
    end
    
    def open
      node = pop_call_stack
      if node
        open_menu([node])
      else
        puts "stack is empty"
      end
    end
    
    def pop_call_stack
      call_stack = YAML.load_file("#{@call_stack_yaml}") || []
      node = call_stack.pop
      File.open("#{@call_stack_yaml}", "w") do |file|
        file.puts YAML.dump(call_stack)
      end
      return node
    end
  end
end