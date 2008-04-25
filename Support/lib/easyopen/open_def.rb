require File.dirname(__FILE__) + '/ui'
require "yaml"

module EasyOpen
  class OpenDefByWord
    include EasyOpen::UI
    def initialize(
        current_word = ENV["TM_CURRENT_WORD"],
        project_dir = ENV["TM_PROJECT_DIRECTORY"], 
        tag_save_dir = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}")

      @current_word = current_word
      @project_dir = project_dir
      @tag_yaml = "#{tag_save_dir}/tag.yaml"
    end
    
    def open
      open_menu(convert_yaml_to_menu_infos)
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