require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/context'
require File.dirname(__FILE__) + '/repository'

module EasyOpen
  class OpenDef
    include EasyOpen::UI
    
    def initialize(context = {})
      Context.setup(context)
      @current_location = { :file => ENV["TM_FILEPATH"], 
                            :line => ENV["TM_LINE_NUMBER"], 
                            :column => ENV["TM_COLUMN_NUMBER"] }
    end
    
    def run
      if open_menu(menu_infos)
        push_call_stack
      end
    end
    
    def push_call_stack
      call_stack = CallStackRepository.load
      call_stack.push @current_location
      CallStackRepository.save call_stack
    end
    
    def menu_infos
      def_index = DefIndexRepository.load
      locationids = def_index[:name_locationIds][Context[:current_word]]
      return [] unless locationids
      return locationids.map do |id|
        file_id = def_index[:locations][id][:file_id]
        filepath = def_index[:files][file_id]
        display = "#{filepath.gsub("#{Context[:project_dir]}/", '')}"+ 
                  ":#{def_index[:locations][id][:line]}" +
                  ": #{def_index[:locations][id][:more_info]}"
        {  
          :file => filepath,
          :line => def_index[:locations][id][:line],
          :column  => def_index[:locations][id][:column],
          :display => display
        }
      end
    end
  end
end
