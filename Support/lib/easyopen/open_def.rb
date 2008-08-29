require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

module EasyOpen
  class OpenDef
    include EasyOpen::UI
    
    def initialize(config = {})
      Config.setup(config)
    end
    
    def run
      if open_menu(menu_infos)
        push_call_stack
      end
    end
    
    def push_call_stack
      call_stack = nil      
      call_stack = CallStackRepository.load
      call_stack.push Config[:current_location]
      CallStackRepository.save call_stack
    end
    
    def menu_infos
      def_index = DefDataRepository.load
      locationids = def_index[:name_locationIds][Config[:current_word]]
      return [] unless locationids
      menu_infos = locationids.map do |id|
        file_id = def_index[:locations][id][:file_id]
        file = def_index[:files][file_id]
        display = "#{file.gsub("#{Config[:project_dir]}/", '')}"+ 
                  ":#{def_index[:locations][id][:line]}" +
                  ":#{def_index[:locations][id][:more_info]}"
        {  
          :file => file,
          :line => def_index[:locations][id][:line],
          :column  => def_index[:locations][id][:column],
          :display => display
        }
      end
      menu_infos
    end
  end
end