require File.dirname(__FILE__) + '/ui'

module EasyOpen
  class OpenRecent
    include EasyOpen::UI
    def initialize(
        project_dir = ENV["TM_PROJECT_DIRECTORY"],
        current_file = ENV["TM_FILEPATH"] )
      @project_dir = project_dir
      @current_file = current_file
    end

    def run
      if @project_dir.nil?
        puts "project_dir is nil. please open project"
        return
      end
      open_menu(menu_infos)
    end

    def menu_infos
      root = @project_dir

      Dir.glob("#{ root }/**/*.*").
        sort_by { |f| File.mtime(f) }.
        reverse[0..10].
        reject { |e| e == @current_file }.
        collect{ |e| 
          dir_base = File.split(e) 
          { 
            :file => e, 
            :display => "#{e.sub(root, "").sub("/", "")}"
          }
        } 
    end
  end
end