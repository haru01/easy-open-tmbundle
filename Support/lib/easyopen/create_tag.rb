require "yaml"
require 'fileutils'

module EasyOpen
  module Tag
    class Generator
      def initialize(
          project_dir = ENV["TM_PROJECT_DIRECTORY"],
          tag_save_dir = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}")
        @project_dir = project_dir
        @tag_save_dir = tag_save_dir
        @tag_yaml = "#{@tag_save_dir}/tag.yaml"
      end
      
      def run
        converter = YamlConverter.new
        Dir.glob("#{@project_dir}/**/*.rb").each do |file_name|
          File.open(file_name) do |file|
            converter.parse(file)
          end
        end
        FileUtils::mkdir_p("#{@tag_save_dir}")
        File.open("#{@tag_yaml}", "w") do |file|
          file.puts converter.to_yaml
        end
        puts "created create_tag_file"
        puts "  filepath=>#{@tag_yaml}"
      end
    end
    
    class YamlConverter
      def initialize
        @locations = []
        @files = []
        @name_locationids = {}
        #TODO molude Hoge::Fugaに対応すること
        @regular = /(^\s*(class|def|module)\s*)(\w*).*$/
      end
      
      def parse(opened_file)
        file = File.expand_path(opened_file.path)
        opened_file.each_with_index do |line, index|
          if m = @regular.match(line)
            name = m[3].to_s
            @files << file unless @files.include?(file)
            @name_locationids[name] ||= []
            @name_locationids[name] << @locations.size 
            @locations << 
              {  
                :file_id => @files.index(file),
                :line => index + 1,
                :column =>  m[1].size + 1,
              }
          end
        end
      end
      
      def to_yaml
        YAML.dump(
            {
              :name_locationids => @name_locationids, 
              :files => @files, 
              :locations => @locations
            })
      end
    end
  end
end
