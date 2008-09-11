require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/javascript_token"

module EasyOpen::Extension
  describe JavaScriptToken do
    before(:each) do
      @token = JavaScriptToken.new
    end
  
    it "should tokeninze 'JSSpec.Executor = function(target, onSuccess, onException) {'" do
      line = 'JSSpec.Executor = function(target, onSuccess, onException) {'
      results = @token.tokenize(line)
      results.should have(1).items
      results[0][:name].should == "Executor"
      results[0][:column].should == "JSSpec.".size + 1
      results[0][:more_info].should == line
    end
  
    it "should tokeninze 'JSSpec.Executor = function (target, onSuccess, onException) {'" do
      results = @token.tokenize('JSSpec.Executor = function (target, onSuccess, onException) {')
      results.size.should == 1
      results[0][:name].should == "Executor"
      results[0][:column].should == "JSSpec.".size + 1
    end
  
    it "should tokenize '  grep: function(filter, iterator, context) {'" do
      line = '  grep: function(filter, iterator, context) {'
      results = @token.tokenize(line)
      results[0][:name].should == "grep"
      results[0][:column].should == "  ".size + 1
      results[0][:more_info].should == line
    end
  end
end