require 'fileutils'
require File.dirname(__FILE__) + '/config'

module EasyOpen
  class CreateDefLocationData
    def initialize(config = {})
      Config.setup(config)
    end
    
    def run
      if Config[:project_dir].nil?
        puts "TM_PROJECT_DIRECTORY is nil. can't create def_location_data"
        exit
      end
      
      visitor = FileVisitor.new
      Dir.glob("#{Config[:project_dir]}/**/*.rb").each do |file_name|
        File.open(file_name) do |file|
          visitor.visit(file)
        end
      end
      FileUtils::mkdir_p("#{Config[:save_dir]}")
      
      open("#{Config[:def_location_dump]}", "w") { |mio|
        Marshal.dump(visitor.create_def_location_data, mio)
      }
      
      open("#{Config[:call_stack_dump]}", "w") { |mio|
        Marshal.dump([], mio)
      }
      
      puts "location_file is created, and call stack file is cleaned."
      puts "save_dir=>#{Config[:save_dir]}"
    end
  end
  
  class FileVisitor
    def initialize
      @locations = []
      @files = []
      @name_locationids = {}
      #TODO molude Hoge::Fugaに対応すること
      @regular = /(^\s*(class|def|module)\s*)(\w*).*$/
    end
    
    def visit(opened_file)
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
    
    def create_def_location_data
      {
        :name_locationids => @name_locationids, 
        :files => @files, 
        :locations => @locations
      }
    end
  end
end
