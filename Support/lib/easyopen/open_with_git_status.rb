require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

module EasyOpen
  class OpenWithGitStatus
    include EasyOpen::UI
    
    def open
      git_status_str = %x[pushd "#{ENV['TM_PROJECT_DIRECTORY']}";  git status]
      menu_infos = menu_infos git_status_str
      open_menu_must_list_show menu_infos
    end
    
    def menu_infos git_status_str
      files = []
      untracked_files_lines = false
      git_status_str.split("\n").each do |line|
        
        if line.include?('Untracked files:')
          untracked_files_lines = true
          next
        end
        
        unless untracked_files_lines
          if m = /^#\s+renamed:.+\s->\s(.+)$/.match(line)
            files << { :file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                       :display => "renamed: #{m[1]}" }
          elsif m = /^#\s+modified:\s+(.+)$/.match(line)
            files << { :file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                       :display => "modified: #{m[1]}" }
          elsif m = /^#\s+new file:\s+(.+)$/.match(line)
            files << { :file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                      :display => "new file: #{m[1]}" }
          end
        else
          if m = /^#\s+([^()]+)$/.match(line)
            files << { :file  => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", 
                       :display => "untrancked: #{m[1]}" }
          end
        end
      end
      
      files
    end
  end
end
