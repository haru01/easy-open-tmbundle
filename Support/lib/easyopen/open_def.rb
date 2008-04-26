require File.dirname(__FILE__) + '/ui'

module EasyOpen
  class OpenDefByWord
    include EasyOpen::UI
    def initialize(
        current_word = ENV["TM_CURRENT_WORD"],
        project_dir = ENV["TM_PROJECT_DIRECTORY"], 
        save_dir = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}",
        current = {:file => ENV["TM_FILEPATH"], 
                  :line => ENV["TM_LINE_NUMBER"], 
                  :column => ENV["TM_COLUMN_NUMBER"]})

      @current_word = current_word
      @project_dir = project_dir
      @call_stack_dump = "#{save_dir}/call_stack.dump"
      @tag_dump = "#{save_dir}/tag.dump"
      @current = current
    end
    
    def run
      if open_menu(convert_dump_to_menu_infos)
        push_call_stack
      end
    end
    
    def push_call_stack
      call_stack = nil
      
      open("#{@call_stack_dump}", "r") { |io|
        call_stack = Marshal.load(io)        
      }
      
      call_stack.push @current
      
      open("#{@call_stack_dump}", "w") { |mio|
        Marshal.dump(call_stack, mio)
      }      
    end
    
    def convert_dump_to_menu_infos
      to_menu_infos load_tag
    end

    def load_tag
      begin
        tag = nil
        open("#{@tag_dump}", "r") { |io|
          tag = Marshal.load(io)
        }
        return tag
      rescue
        puts "not found tag file. please create_tag_file before open_def"
        exit
      end
    end

    def to_menu_infos tag
      locationids = tag[:name_locationids][@current_word]
      return [] unless locationids
      result = locationids.map do |id|
        file_id = tag[:locations][id][:file_id]
        file = tag[:files][file_id]
        {  
          :file => file,
          :line => tag[:locations][id][:line],
          :column  => tag[:locations][id][:column],
          :display => "#{file.gsub("#{@project_dir}/", '')}"
        }
      end
      result
    end    
  end
end