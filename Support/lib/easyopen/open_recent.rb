require File.dirname(__FILE__) + '/ui'

module EasyOpen
  class OpenByRecent
    include EasyOpen::UI
    def initialize(home = ENV["HOME"], 
        project_dir = ENV["TM_PROJECT_DIRECTORY"],
        current_file = ENV["TM_FILEPATH"] )
      @home = home
      @project_dir = project_dir
      @current_file = current_file
    end

    def run
      open_menu(menu_infos)
    end

    def menu_infos
      root = @project_dir
      root ||= @home

      Dir.glob("#{ root }/**/*.*").
        sort_by { |f| File.mtime(f) }.
        reverse[0..10].
        reject { |e| e == @current_file }.
        collect{ |e| 
          dir_base = File.split(e) 
          { :file => e, 
            :display => "#{e.sub(root, "").sub("/", "")}"
          }
        } 
    end
  end
end