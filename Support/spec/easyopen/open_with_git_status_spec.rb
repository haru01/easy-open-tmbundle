require File.dirname(__FILE__) + "/../../lib/easyopen/config"
require File.dirname(__FILE__) + "/../../lib/easyopen/ui"
require File.dirname(__FILE__) + "/../../lib/easyopen/open_with_git_status"


class TestUI
  include EasyOpen::UI
end

module EasyOpen
  describe "subject" do
    before(:each) do
      puts File.dirname(__FILE__) + "/../../lib/easyopen/open_with_git_status"
      
      @subject = OpenWithGitStatus.new
      
      @git_status_str =<<GIT
# On branch try-git-status
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	new file:   Commands/open_with_git_status.tmCommand
#	modified:   README
#	deleted:    Support/spec/easyopen/open_with_git_status.rb
#
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	renamed:    Support/fixtures/ruby_code.rb -> Support/fixtures/renamed_ruby_code.rb
#
# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   README
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#	hoge.txt
GIT
    end
    it "---- check manual" do
      TestUI.new.open_menu( @subject.menu_infos(@git_status_str) )
    end
  end
end