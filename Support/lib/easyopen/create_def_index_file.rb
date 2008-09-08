require 'fileutils'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

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
      Dir.glob("#{Config[:project_dir]}/**/*.{rb,js}").each do |file_name|
        parser.parse(file_name)
      end
      FileUtils::mkdir_p("#{Config[:save_dir]}")
      DefDataRepository.save parser.def_index      
      CallStackRepository.init
      puts "created def index file, and cleaned call stack file"
      puts "save_dir=>#{Config[:save_dir]}"
    end
  end

  class JavaScriptToken
    def tokenize(line)
      if m = /^([^\s]*)\s*=\s*function(\(.*\)).*\{.*$/.match(line)
        name = m[1].split(".").last
        tmp = m[1].split(".")
        tmp.pop
        pre = tmp.join(".")
        pre += "."
        {
          :def => "function",
          :names => m[1].split(".").last,
          :args => m[2],
          :pre_first_name => pre

        }
      end        
    end
  end
  
  class RubyToken
    def tokenize(line)
      if m = /(^\s*(class|def|module)\s*)([\w:\.]*)(.*)$/.match(line)
        names = if m[3].include?("self.")
          m[3].gsub("self.", "")
        else
          m[3].split("::")
        end
        
        pre_first_name = m[1]
        pre_first_name += "self." if m[3].include?("self.")
        
        {
          :def => m[2],
          :pre_first_name => pre_first_name,
          :names => names,
          :args => m[4]
        }
      end
    end
  end
  
  class Parser
    def initialize
      @locations = []
      @files = []
      @name_locationIds = {}
      @tokens = { 
        ".rb" => RubyToken.new,
        ".js" => JavaScriptToken.new,
      }
    end
    
    def parse(file_name)
      File.open(file_name) do |file|
        file.each_with_index do |line, index|
          token = @tokens[File.extname(file_name)]
          unless token
            puts "not support extname=>#{File.extname(file_name)}"
            return
          end
          if t = @tokens[File.extname(file_name)].tokenize(line)
            colum = t[:pre_first_name].size + 1
            t[:names].each_with_index { |name, ind|
              colum += t[:names][ind-1].size + "::".size if ind != 0
              t[:def] == "def" ? more_info = t[:args] : more_info = line
              @files << file_name unless @files.include?(file_name)
              @name_locationIds[name] ||= []
              @name_locationIds[name] << @locations.size 
              @locations << 
                {
                  :file_id => @files.index(file_name),
                  :line => index + 1,
                  :column =>  colum,
                  :more_info => more_info
                }
            }
          end
        end
      end
    end

    # example
    #    {:name_locationIds=>
    #      {...
    #       "RubyToken"=>[29],
    #       "tokenize"=>[30],
    #       ...
    #       "initialize"=>[18, 27, 32, 38, 45], # locationid '38' is CreateDefIndexFile#initialize
    #       ...},
    #     :locations=>
    #      [{:column=>7, :line=>1, :more_info=>"class Hooooo\n", :file_id=>0}, #0
    #       {:column=>6, :line=>2, :more_info=>"", :file_id=>0}, #1
    #       ...
    #       {:column=>9,
    #        :line=>6,
    #        :more_info=>"  class CreateDefIndexFile\n",
    #        :file_id=>3}, #29 file_id=>3 is create_def_index_file.rb
    #        ...
    #       {:column=>9, :line=>28, :more_info=>"  class RubyToken\n", :file_id=>3}, 
    #       {:column=>9, :line=>29, :more_info=>"(line)", :file_id=>3},
    #       ...
    #       {:column=>9, :line=>7, :more_info=>"(config = {})", :file_id=>3},
    #       ...],
    #     :files=>
    #      ["/Users/haru01/Library/Application Support/TextMate/Bundles/EasyOpen.tmbundle/Support/fixtures/ruby_code.rb", #0
    #       "/Users/haru01/Library/Application Support/TextMate/Bundles/EasyOpen.tmbundle/Support/lib/easyopen/back_open_def.rb", #1
    #       "/Users/haru01/Library/Application Support/TextMate/Bundles/EasyOpen.tmbundle/Support/lib/easyopen/config.rb", #2
    #       "/Users/haru01/Library/Application Support/TextMate/Bundles/EasyOpen.tmbundle/Support/lib/easyopen/create_def_index_file.rb", #3
    #        ...]
    #    }
    def def_index
      {
        :name_locationIds => @name_locationIds, 
        :files => @files, 
        :locations => @locations
      }
    end
  end
end
