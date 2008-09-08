require File.dirname(__FILE__) + "/../../lib/easyopen/token"

module EasyOpen
  describe JavaScriptToken do
    before(:each) do
      @token = JavaScriptToken.new
    end
  
    it "should tokeninze 'JSSpec.Executor = function(target, onSuccess, onException) {'" do
      result = @token.tokenize('JSSpec.Executor = function(target, onSuccess, onException) {')
      result[:names].should == "Executor"
      result[:pre_first_str].should == "JSSpec."      
    end
  
    it "should tokeninze 'JSSpec.Executor = function (target, onSuccess, onException) {'" do
      result = @token.tokenize('JSSpec.Executor = function (target, onSuccess, onException) {')
      result[:names].should == "Executor"
      result[:pre_first_str].should == "JSSpec."      
    end
  
    it "should tokenize '  grep: function(filter, iterator, context) {'" do
      result = @token.tokenize('  grep: function(filter, iterator, context) {')
      result[:names].should == "grep"
      result[:pre_first_str].should == "  "          
    end
  end
  
  describe RubyToken do
    before(:each) do
      @token = RubyToken.new
    end
  
    it "should tokenize '	def self.hogefuga(hoge, foo)'" do
      result = @token.tokenize('	def self.hogefuga(hoge, foo)')
      result[:names].should == "hogefuga"
      result[:pre_first_str].should == "	def self."
    end
  
    it "should tokenize '	def open(hoge, foo)'" do
      line = "	def open(hoge, foo)"
      @token.tokenize(line)[:pre_first_str].should == "	def "
      @token.tokenize(line)[:names].should == ["open"]
    end
  
    it "should tokenize 'module Hoge::Hogeogeoge'" do
      line = 'module Hoge::Hogeogeoge'
      @token.tokenize(line)[:pre_first_str].should == "module "
      @token.tokenize(line)[:names].should == ["Hoge", "Hogeogeoge"]
    end
  
    it "should tokenize return nil if not include def module class" do
      line = '      '
      @token.tokenize(line).should be_nil
    end
  
    it "should tokenize return nil if comment def module class" do
      line = ' # def hoge'
      @token.tokenize(line).should be_nil
    end
  end
end