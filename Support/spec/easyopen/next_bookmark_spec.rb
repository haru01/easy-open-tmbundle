require File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark"


describe "rotate_bookmarks, when one file" do
  before(:each) do
    @dup_file = File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark.rb"
    @dup_line = "1"
    @bookmarks = 
      [ {:file => @dup_file,
         :line => @dup_line},
       ]
  end

  it "should select 1" do
    expects = rotate_bookmarks(@bookmarks)
    expects.should have(1).items
    expects[0][:line].should == "1"
  end
  
  it "should select 1, when dup file and line" do
    expects = rotate_bookmarks(@bookmarks, @dup_file, @dup_line)
    expects.should have(1).items
    expects[0][:line].should == "1"
  end
end

describe "rotate_bookmarks, when valid bookmarks" do
  before(:each) do
    @dup_file = File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark.rb"
    @dup_line = "1"
    @bookmarks = 
      [ {:file => @dup_file,
         :line => @dup_line},
         {:file => File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark.rb", 
          :line => "2"},
         {:file => File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark.rb", 
          :line => "3"}
     ]    
  end
  
  it "should one shift, when not match current file & line" do
    expects = rotate_bookmarks(@bookmarks)
    expects.last[:line].should == "1"
  end
  
  # Why: I want to move from current file & line to other
  it "should two shift, when match current file & line" do
    expects = rotate_bookmarks(@bookmarks, @dup_file, @dup_line)
    expects.last[:line].should == "2"
  end
end

describe "rotate_bookmarks, when not found line" do
  before(:each) do
    @bookmarks = 
        [
          {:file => File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark.rb", 
          :line => "999999"}, # not found
          ]
  end
  # Why: I want to remove invalid bookmark
  it "should remove" do
    expects = rotate_bookmarks(@bookmarks)
    expects.should have(0).items
  end
end

describe "rotate_bookmarks, when not found file" do
  before(:each) do
    @bookmarks = 
        [
          {:file => "notfound", 
          :line => "1"},
          {:file => "notfound", 
          :line => "2"},
          {:file => "notfound", 
          :line => "3"},          
          {:file => File.dirname(__FILE__) + "/../../lib/easyopen/next_bookmark.rb", 
          :line => "4"},
          ]
  end
  # Why: I want to remove invalid bookmark
  it "should remove" do
    expects = rotate_bookmarks(@bookmarks)
    expects[0][:line].should == "4"
    expects.should have(1).items
  end
end

describe "rotate_bookmarks, when not found file ALL!" do
  before(:each) do
    @bookmarks = 
        [
          {:file => "notfound", 
          :line => "1"},
          {:file => "notfound", 
          :line => "2"},
          {:file => "notfound", 
          :line => "3"},          
          ]
  end
  # Why: I want to remove invalid bookmark
  it "should remove" do
    expects = rotate_bookmarks(@bookmarks)
    expects.should have(:no).items
  end
end

