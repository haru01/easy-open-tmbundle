require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/javascript_token"

module EasyOpen::Extension
  describe JavaScriptToken do
    before(:each) do
      @token = JavaScriptToken.new
    end
  
    it "should tokeninze 'JSSpec.Executor = function(target, onSuccess, onException) {'" do
      line = 'JSSpec.Executor = function(target, onSuccess, onException) {'
      result = @token.tokenize(line)
      result[:name].should == "Executor"
      result[:column].should == "JSSpec.".size + 1
      result[:more_info].should == line
    end
  
    it "should tokeninze 'JSSpec.Executor = function (target, onSuccess, onException) {'" do
      result = @token.tokenize('JSSpec.Executor = function (target, onSuccess, onException) {')
      result[:name].should == "Executor"
      result[:column].should == "JSSpec.".size + 1
    end
  
    it "should tokenize '  grep: function(filter, iterator, context) {'" do
      line = '  grep: function(filter, iterator, context) {'
      result = @token.tokenize(line)
      result[:name].should == "grep"
      result[:column].should == "  ".size + 1
      result[:more_info].should == line
    end
  end
end