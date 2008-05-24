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

  class Token
    def tokenize(line)
      if m = /(^\s*(class|def|module)\s*)([\w:]*)(.*)$/.match(line)
        {
          :def => m[2],
          :pre_first_name => m[1],
          :names => m[3].split("::"),
          :args => m[4]
        }
      end
    end
  end
  
  class Parser
    def initialize
      @locations = []
      @files = []
      @name_locationids = {}
      @token = Token.new
    end
    
    def parse(file_name)
      File.open(file_name) do |file|
        file.each_with_index do |line, index|
          if t = @token.tokenize(line)
            line = index + 1
            first_colum = t[:pre_first_name].size + 1
            t[:names].each_with_index { |name, ind|
              t[:def] == "def" ? more_info = t[:args] : more_info = t[:def]
              @files << file_name unless @files.include?(file_name)
              @name_locationids[name] ||= []
              @name_locationids[name] << @locations.size 
              @locations << 
                {
                  :file_id => @files.index(file_name),
                  :line => index + 1,
                  :column =>  first_colum, #TODO Hoge::Fooの移動先にも対応すること
                  :more_info => more_info
                }
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
