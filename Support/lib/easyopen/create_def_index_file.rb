require 'fileutils'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'
require File.dirname(__FILE__) + '/extension/user_conf'

module EasyOpen
  class CreateDefIndexFile
    def initialize(config = {})
      Config.setup(config)
    end
    
    def run
      if Config[:project_dir].nil?
        puts "TM_PROJECT_DIRECTORY is nil. can't create def_index_file"
        exit
      end
      parser = Parser.new
      extnames = EasyOpen::Extension::UserConf.tokens.keys.join(",")
      Dir.glob("#{Config[:project_dir]}/**/*.{#{extnames}}").each do |file_name|
        parser.parse(file_name)
      end
      DefIndexRepository.save parser.def_index      
      CallStackRepository.init
      puts "created def index file, and cleaned call stack file"
      puts "save_dir=>#{Config[:save_dir]}"
    end
  end
  
  class Parser
    def initialize(tokens = Extension::UserConf.tokens)
      @locations = []
      @files = []
      @name_locationIds = {}
      @tokens = tokens
    end
    
    def parse(file_name)
      File.open(file_name) do |file|
        file.each_with_index do |line, index|
          token = @tokens[File.extname(file_name).sub(".", "")]
          unless token
            puts "not support extname=>#{File.extname(file_name)}"
            return
          end
          if t = token.tokenize(line)
              @files << file_name unless @files.include?(file_name)
              @name_locationIds[t[:name]] ||= []
              @name_locationIds[t[:name]] << @locations.size 
              @locations << 
                {
                  :file_id => @files.index(file_name),
                  :line => index + 1,
                  :column =>  t[:column],
                  :more_info => t[:more_info],
                }
          end
        end
      end
    end

    def def_index
      {
        :name_locationIds => @name_locationIds, 
        :files => @files, 
        :locations => @locations
      }
    end
  end
end
