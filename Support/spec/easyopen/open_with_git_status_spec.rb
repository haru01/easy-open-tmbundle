require File.dirname(__FILE__) + "/../../lib/easyopen/context"
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

      @git_status_str =<<GIT_STATUS
 D Support/lib/easyopen/open_mdfind.rb
 M Support/lib/easyopen/open_with_git_status.rb
?? untitled.rb
A  untitled.rb
GIT_STATUS
    end
    it "---- check manual" do
      TestUI.new.open_menu( @subject.menu_infos(@git_status_str) )
    end
  end
end
