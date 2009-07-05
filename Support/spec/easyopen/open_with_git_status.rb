require File.dirname(__FILE__) + "/../../lib/easyopen/config"
require File.dirname(__FILE__) + "/../../lib/easyopen/ui"

class TestUI
  include EasyOpen::UI
end

module EasyOpen
  describe "subject" do
    it "does something" do
      gs = `pushd "#{ENV['TM_PROJECT_DIRECTORY']}"; git status`
      files = []
      untracked_files_lines = false
      gs.split("\n").each {|line|
        if line.include?('Untracked files:')
          untracked_files_lines = true
          next
        end
        if m = /^#\s+modified:\s+(.+)$/.match(line)
          files << {:file => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", :display => "modified: #{m[1]}"}
        end
        if untracked_files_lines
          if m = /^#\s+([^()]+)$/.match(line)
            files << {:file  => "#{ENV['TM_PROJECT_DIRECTORY']}/#{m[1]}", :display => "untrancked: #{m[1]}"}
          end
        end
      }
      include EasyOpen::UI
      TestUI.new.open_menu(files)
      puts untracked_files
    end
  end
end