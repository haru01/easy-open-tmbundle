require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/js_token"

module EasyOpen::Extension
  describe JsToken do
    before(:each) do
      @token = JsToken.new
    end
    
    it "should tokinize '    color : function(string, color) {'" do
      line =  '    color : function(string, color) {'
      result = @token.tokenize(line)
      result[:name].should == "color"
      result[:column].should == "    ".size + 1
      result[:more_info].should == line      
    end
    
    it "should tokenize '  be_empty: {'" do
      line =   '  be_empty: {'
      result = @token.tokenize(line)
      result[:name].should == "be_empty"
      result[:column].should == "  ".size + 1
      result[:more_info].should == line
    end

    it "should tokenize '  function define(self, name, fn) {'" do
      line =   '  function define(self, name, fn) {'
      result = @token.tokenize(line)
      result[:name].should == "define"
      result[:column].should == "  function ".size + 1
      result[:more_info].should == line
    end

    it "should tokenize 'function makeBlock (f) {'" do
      line =  'function makeBlock (f) {'
      result = @token.tokenize(line)
      result[:name].should == "makeBlock"
      result[:column].should == "function ".size + 1
      result[:more_info].should == line
    end
      
    it "should tokeninze ' JSSpec.Executor = function(target, onSuccess, onException) {'" do
      line = ' JSSpec.Executor = function(target, onSuccess, onException) {'
      result = @token.tokenize(line)
      result[:name].should == "Executor"
      result[:column].should == " JSSpec.".size + 1
      result[:more_info].should == line
    end

    it "should tokeninze '  to = function(matcher) {'" do
      line = '  to = function(matcher) {'
      result = @token.tokenize(line)
      result[:name].should == "to"
      result[:column].should == "  ".size + 1
      result[:more_info].should == line
    end
  
    it "should tokenize '  grep: function(filter, iterator, context) {'" do
      line = '  grep: function(filter, iterator, context) {'
      result = @token.tokenize(line)
      result[:name].should == "grep"
      result[:column].should == "  ".size + 1
      result[:more_info].should == line
    end

    it "should tokenize 'assert.ok = function ok(value, message) {'" do
      line = 'assert.ok = function ok(value, message) {'
      result = @token.tokenize(line)
      result[:name].should == "ok"
      result[:column].should == "assert.ok = function ".size + 1
      result[:more_info].should == line
    end
  end
end