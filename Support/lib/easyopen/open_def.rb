require File.dirname(__FILE__) + '/ui'
require "yaml"

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
      @call_stack_yaml = "#{save_dir}/call_stack.yaml"
      @tag_yaml = "#{save_dir}/tag.yaml"
      @current = current
    end
    
    def open
      if open_menu(convert_yaml_to_menu_infos)
        push_call_stack
      end
    end
    
    def push_call_stack
      if File.exist?(@call_stack_yaml)
        call_stack = YAML.load_file("#{@call_stack_yaml}")
      end
      call_stack ||= []
      call_stack.push @current
      File.open("#{@call_stack_yaml}", "w") do |file|
        file.puts YAML.dump(call_stack)
      end
    end

    def convert_yaml_to_menu_infos
      tag = nil
      begin
        tag = YAML.load_file("#{@tag_yaml}")
      rescue
        puts "not found tag file. please create_tag_file before open_def"
        exit
      end
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