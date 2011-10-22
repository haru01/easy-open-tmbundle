require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/context'
require File.dirname(__FILE__) + '/repository'

module EasyOpen
  class OpenWithGitStatus
    include EasyOpen::UI

    def open
      git_status_str = %x[pushd "#{ENV['TM_PROJECT_DIRECTORY']}";  git status -s]
      menu_infos = menu_infos(git_status_str)
      open_menu_list(menu_infos)
    end

    def menu_infos(git_status_str)
      git_status_str.split("\n")
                    .select{|line| line.start_with?(" M") or line.start_with?("A") or line.start_with?("??") or line.start_with?(" D") }
                    .inject([]) do |files, line|
        status, filepath = line.split(" ").map(&:strip)
        files << { :file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{filepath}",
                 :display => "#{line}" }
      end
    end
  end
end
