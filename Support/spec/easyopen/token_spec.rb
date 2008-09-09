require File.dirname(__FILE__) + "/../../lib/easyopen/token"

module EasyOpen
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
  
  describe RubyToken do
    before(:each) do
      @token = RubyToken.new
    end
  
    it "should tokenize '	def self.hogefuga(hoge, foo)'" do
      line = '	def self.hogefuga(hoge, foo)'
      results = @token.tokenize(line)
      results.should have(1).items
      results[0][:name].should == "hogefuga"
      results[0][:column].should == "	def self.".size + 1
      results[0][:more_info].should == line
    end
  
    it "should tokenize '	def open(hoge, foo)'" do
      line = "	def open(hoge, foo)"
      results = @token.tokenize(line)
      results.should have(1).items
      results[0][:name].should == "open"
      results[0][:column].should == "	def ".size + 1
      results[0][:name].should == "open"
    end
  
    it "should tokenize 'module Hoge::Hogeogeoge'" do
      line = 'module Hoge::Hogeogeoge'
      results = @token.tokenize(line)
      results.should have(2).items
      results[0][:column].should == "module ".size + 1
      results[0][:name].should == "Hoge"
      results[1][:column].should == "module Hoge::".size + 1
      results[1][:name].should == "Hogeogeoge"
      results[1][:more_info].should == line
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