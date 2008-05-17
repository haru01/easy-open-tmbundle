require 'fileutils'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

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
      DefDataRepository.save parser.def_data      
      CallStackRepository.init
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
      @regular = /(^\s*(class|def|module)\s*)(\w*)(.*)$/
    end
    
    def parse(file_name)
      File.open(file_name) do |file|
        file.each_with_index do |line, index|
          if m = @regular.match(line)
            name = m[3].to_s
            args = m[4].to_s if m[2].to_s == "def"
            @files << file_name unless @files.include?(file_name)
            @name_locationids[name] ||= []
            @name_locationids[name] << @locations.size 
            @locations << 
              {
                :file_id => @files.index(file_name),
                :line => index + 1,
                :column =>  m[1].size + 1,
                :args => args
              }
          end
        end
      end
    end
    
    def def_data
      {
        :name_locationids => @name_locationids, 
        :files => @files, 
        :locations => @locations
      }
    end
  end
end
