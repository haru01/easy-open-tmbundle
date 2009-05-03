require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'


module EasyOpen
  class OpenRecent
    include EasyOpen::UI
    
    def initialize
      @project_dir = Config[:project_dir]
      @current_file = Config[:current_file]
    end

    def run
      if @project_dir.nil?
        puts "project_dir is nil. please open project"
        return
      end
      open_menu(recent_infos)
    end

    def recent_infos
      Dir.glob("#{@project_dir}/**/*.*").
        sort_by { |f| File.mtime(f) }.
        reverse[0..10].
        reject { |e| e == @current_file }.
        reject { |e| !!e.match(/.*\.log$/) }.
        reject { |e| !!e.match(/.*\.sqlite3$/) }.
        map { |e| 
          { 
            :file => e, 
            :display => "#{e.sub(@project_dir, "").sub("/", "")}"
          }
        }
    end
  end
end