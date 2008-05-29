require File.dirname(__FILE__) + "/../../lib/easyopen/ui"

module EasyOpen::UI
  class TestTarget
    include EasyOpen::UI
  end
  
  describe "EasyOpen::UI open_menu, " do
    before(:each) do
      @target = TestTarget.new
    end
    
    describe "when infos size is zero" do
      it "should show 'not found' message" do
        @target.should_receive(:puts).with("not found")
        @target.open_menu([]).should be_nil
      end
    end
    
    describe "when infos size is one" do
      before(:each) do
        @dummy = {
          :file => "dummy_file",
          :line => "dummy_line",
          :column  => "dummy_column",
          :display => "dummy_display"
        }
        @infos = [@dummy]
      end
      
      it "should open file" do
        @target.should_receive(:go_to).with(@dummy)
        @target.open_menu(@infos).should == @dummy
      end
    end
    
    describe "when infos size is not(zero and one)" do
      before(:each) do
        @dummy1 = {  
          :file => "dummy_file1",
          :line => "dummy_line1",
          :column  => "dummy_column1",
          :display => "dummy_display1"
        }
        @dummy2 = {  
          :file => "dummy_file2",
          :line => "dummy_line2",
          :column  => "dummy_column2",
          :display => "dummy_display2"
        }
        @infos = [@dummy1, @dummy2]
      end
      
      it "should open menu-> open file" do
        TextMate::UI.should_receive(:menu).with(["dummy_display1", "dummy_display2"]).and_return(1)
        @target.should_receive(:go_to).with(@dummy2)
        @target.open_menu(@infos).should == @dummy2
      end
    end
  end
end
