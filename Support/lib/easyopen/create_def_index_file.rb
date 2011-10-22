require 'fileutils'
require File.dirname(__FILE__) + '/context'
require File.dirname(__FILE__) + '/repository'
require File.dirname(__FILE__) + '/extension/user_conf'

module EasyOpen
  class CreateDefIndexFile
    def initialize(context = {})
      Context.setup(context)
    end
    
    def run
      if Context[:project_dir].nil?
        puts "TM_PROJECT_DIRECTORY is nil. can't create def_index_file"
        exit
      end
      parser = Parser.new
      extnames = EasyOpen::Extension::UserConf.tokens.keys.join(",")
      Dir.glob("#{Context[:project_dir]}/**/*.{#{extnames}}").each do |file_name|
        parser.parse(file_name)
      end
      DefIndexRepository.save parser.def_index      
      CallStackRepository.init
      puts "created def index file, and cleaned call stack file"
      puts "save_dir=>#{Context[:save_dir]}"
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

          line = convert_exp_able(line)
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
    
    def convert_exp_able(line)
      begin
        /^/.match(line)
      rescue Exception => e
        return line.encode("UTF-16BE", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8")             
      end
      line
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
