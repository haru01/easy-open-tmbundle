require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/context'


module EasyOpen
  class OpenRecent
    include EasyOpen::UI

    def initialize
      @project_dir = Context[:project_dir]
      @current_file = Context[:current_file]
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
        reject { |e| e == @current_file }.
        reject { |e| !!e.match(/.*\.log$/) }.
        reject { |e| !!e.match(/.*coverage.*$/) }.
        reject { |e| !!e.match(/.*tmp\/.*$/) }.
        sort_by { |f| File.mtime(f) }.
        reverse[0..10].
        map { |e|
          {
            :file => e,
            :display => "#{e.sub(@project_dir, "").sub("/", "")}"
          }
        }
    end
  end
end
