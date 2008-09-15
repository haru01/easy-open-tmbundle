require File.dirname(__FILE__) + "/../../lib/easyopen/config"

module EasyOpen
  describe Config do
    it "should default" do
      Config.defaults[:project_dir].should == ENV["TM_PROJECT_DIRECTORY"]
      Config.defaults[:current_word].should == ENV['TM_CURRENT_WORD']
      Config.defaults[:save_dir].should == "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}"
      Config.defaults[:def_index_file].should == "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}/def_index.dump"
      Config.defaults[:call_stack_file].should == "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}/call_stack.dump"
      Config.defaults[:current_file].should == ENV['TM_FILEPATH']
    end
    
    it "should return config value" do
      Config[:project_dir].should == ENV["TM_PROJECT_DIRECTORY"]
    end
    
    it "should setup config value" do
      Config.setup({:project_dir => "new_dir", :hoge => "hoge"})
      Config[:project_dir].should == "new_dir"
      Config[:hoge].should == "hoge"
    end
  end
end