require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'

module EasyOpen
  class OpenDef
    include EasyOpen::UI
    
    def initialize(config = {})
      Config.setup(config)
    end
    
    def run
      if open_menu(convert_dump_to_menu_infos)
        push_call_stack
      end
    end
    
    def push_call_stack
      call_stack = nil
      
      open("#{Config[:call_stack_dump]}", "r") { |io|
        call_stack = Marshal.load(io)        
      }
      
      call_stack.push Config[:current_location]
      
      open("#{Config[:call_stack_dump]}", "w") { |mio|
        Marshal.dump(call_stack, mio)
      }
    end
    
    def convert_dump_to_menu_infos
      to_menu_infos load_location_data
    end

    def load_location_data
      begin
        def_location_data = nil
        open("#{Config[:def_location_dump]}", "r") { |io|
          def_location_data = Marshal.load(io)
        }
        return def_location_data
      rescue
        puts "not found def_location_data file. please create_def_location_data_file before open_def"
        exit
      end
    end

    def to_menu_infos def_location_data
      locationids = def_location_data[:name_locationids][Config[:current_word]]
      return [] unless locationids
      result = locationids.map do |id|
        file_id = def_location_data[:locations][id][:file_id]
        file = def_location_data[:files][file_id]
        {  
          :file => file,
          :line => def_location_data[:locations][id][:line],
          :column  => def_location_data[:locations][id][:column],
          :display => "#{file.gsub("#{Config[:project_dir]}/", '')}:#{def_location_data[:locations][id][:line]}"
        }
      end
      result
    end
  end
end