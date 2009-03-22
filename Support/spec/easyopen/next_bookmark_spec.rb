require File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark"


describe "rotate_bookmarks, when valid bookmarks" do
  before(:each) do
    @dup_file = File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark"
    @dup_line = "1"
    @bookmarks = 
      [ {:file => @dup_file,
         :line => @dup_line},
         {:file => File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark", 
          :line => "2"},
         {:file => File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark", 
          :line => "3"}
     ]    
  end
  
  it "should one shift, when not match current file & line" do
    expects = rotate_bookmarks(@bookmarks)
    expects.last[:line].should == "1"
  end
  
  # Why: I want to move from current file & line to other
  it "should two shift, when match current file & line" do
    ENV['TM_FILEPATH'] = @dup_file
    ENV['TM_LINE_NUMBER'] = @dup_line
    expects = rotate_bookmarks(@bookmarks)
    expects.last[:line].should == "2"
  end
end

describe "rotate_bookmarks, when not found file" do
  before(:each) do
    @not_exist_file = { 
      :file => File.dirname(__FILE__) + "/../../lib/easyopen/not_exsit_file",
      :line => "1"}
    @bookmarks2 = 
        [@not_exist_file, {:file => File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark", 
          :line => "2"}]
  end
  # Why: I want to remove invalid bookmark
  it "should remove" do
    pending
    expects = rotate_bookmarks(@bookmarks2)
    expects.size.should == 1
  end
end