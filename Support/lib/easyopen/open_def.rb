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
      if open_menu(convert_menu_infos(DefDataRepository.load))
        push_call_stack
      end
    end
    
    def push_call_stack
      call_stack = nil      
      call_stack = CallStackRepository.load
      call_stack.push Config[:current_location]
      CallStackRepository.save call_stack
    end
    
    def convert_menu_infos def_location_data
      locationids = def_location_data[:name_locationids][Config[:current_word]]
      return [] unless locationids
      menu_infos = locationids.map do |id|
        file_id = def_location_data[:locations][id][:file_id]
        file = def_location_data[:files][file_id]
        {  
          :file => file,
          :line => def_location_data[:locations][id][:line],
          :column  => def_location_data[:locations][id][:column],
          :display => "#{file.gsub("#{Config[:project_dir]}/", '')}:#{def_location_data[:locations][id][:line]}"
        }
      end
      menu_infos
    end
  end
end