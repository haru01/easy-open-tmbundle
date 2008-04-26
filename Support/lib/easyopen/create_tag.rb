require 'fileutils'

module EasyOpen
  module Tag
    class Generator
      def initialize(
          project_dir = ENV["TM_PROJECT_DIRECTORY"],
          save_dir = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}")
        @project_dir = project_dir
        @save_dir = save_dir
        @tag_dump = "#{@save_dir}/tag.dump"
        @call_stack_dump = "#{@save_dir}/call_stack.dump"
      end
      
      def run
        if @project_dir.nil?
          puts "TM_PROJECT_DIRECTORY is nil. not create tag"
          exit
        end
        
        visitor = FileVisitor.new
        Dir.glob("#{@project_dir}/**/*.rb").each do |file_name|
          File.open(file_name) do |file|
            visitor.visit(file)
          end
        end
        FileUtils::mkdir_p("#{@save_dir}")
        
        open("#{@tag_dump}", "w") { |mio|
          Marshal.dump(visitor.create_def_location_data, mio)
        }
        
        open("#{@call_stack_dump}", "w") { |mio|
          Marshal.dump([], mio)
        }
        
        puts "created. save_dir=>#{@save_dir}"
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
end
