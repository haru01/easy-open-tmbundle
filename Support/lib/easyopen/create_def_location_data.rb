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
      
      parser = Parser.new
      Dir.glob("#{Config[:project_dir]}/**/*.rb").each do |file_name|
        parser.parse(file_name)
      end
      FileUtils::mkdir_p("#{Config[:save_dir]}")
      
      open("#{Config[:def_location_dump]}", "w") { |mio|
        Marshal.dump(parser.create_def_location_data, mio)
      }
      
      open("#{Config[:call_stack_dump]}", "w") { |mio|
        Marshal.dump([], mio)
      }
      
      puts "location_file is created, and call stack file is cleaned."
      puts "save_dir=>#{Config[:save_dir]}"
    end
  end
  
  class Parser
    def initialize
      @locations = []
      @files = []
      @name_locationids = {}
      #TODO molude Hoge::Fugaに対応すること
      @regular = /(^\s*(class|def|module)\s*)(\w*).*$/
    end
    
    def parse(file_name)
      File.open(file_name) do |file|
        file.each_with_index do |line, index|
          if m = @regular.match(line)
            name = m[3].to_s
            @files << file_name unless @files.include?(file_name)
            @name_locationids[name] ||= []
            @name_locationids[name] << @locations.size 
            @locations << 
              {
                :file_id => @files.index(file_name),
                :line => index + 1,
                :column =>  m[1].size + 1,
              }
          end
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
