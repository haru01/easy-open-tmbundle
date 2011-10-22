require File.dirname(__FILE__) + "/../../lib/easyopen/context"

module EasyOpen
  describe Context do
    it "should default" do
      Context.defaults[:project_dir].should == ENV["TM_PROJECT_DIRECTORY"]
      Context.defaults[:current_word].should == ENV['TM_CURRENT_WORD']
      Context.defaults[:save_dir].should == "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}"
      Context.defaults[:def_index_file].should == "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}/def_index.dump"
      Context.defaults[:call_stack_file].should == "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}/call_stack.dump"
      Context.defaults[:current_file].should == ENV['TM_FILEPATH']
    end
    
    it "should return context value" do
      Context[:project_dir].should == ENV["TM_PROJECT_DIRECTORY"]
    end
    
    it "should setup context value" do
      Context.setup({:project_dir => "new_dir", :hoge => "hoge"})
      Context[:project_dir].should == "new_dir"
      Context[:hoge].should == "hoge"
    end
  end
end
