require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

module EasyOpen
  class OpenWithGitStatus
    include EasyOpen::UI
    
    def open
      git_status_str = %x[pushd "#{ENV['TM_PROJECT_DIRECTORY']}";  git status]
      menu_infos = menu_infos(git_status_str)
      open_menu_list(menu_infos)
    end
    
    def menu_infos(git_status_str)
      git_status_str.split("\n").inject([]) do |files, line|                
        if m = /^#\trenamed:.+\s->\s(.+)$/.match(line)
          files << { :file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                     :display => "renamed: #{m[1]}" }
        elsif m = /^#\tmodified:\s+(.+)$/.match(line)
          files << { :file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                     :display => "modified: #{m[1]}" }
        elsif m = /^#\tnew file:\s+(.+)$/.match(line)
          files << { :file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                    :display => "new file: #{m[1]}" }
        elsif m = /^#\tdeleted:\s+(.+)$/.match(line)
          # ignore
        elsif m = /^#\t([^()]+)$/.match(line)
          files << { :file  => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                     :display => "untrancked: #{m[1]}" }
        end
        files
      end      
    end
  end
end
