require File.dirname(__FILE__) + "/../../lib/easyopen/token"

describe JavaScriptToken do
  before(:each) do
    @token = JavaScriptToken.new
  end
  
  it "should tokeninze class" do
    result = @token.tokenize('JSSpec.Executor = function(target, onSuccess, onException) {')
    result[:def].should == "function"
    result[:names].should == "Executor"
    result[:args].should == "(target, onSuccess, onException)"
    result[:pre_first_str].should == "JSSpec."      
  end
end
  
describe RubyToken do
  before(:each) do
    @token = RubyToken.new
  end
  
  it "should tokenize '	def self.hogefuga(hoge, foo)'" do
    result = @token.tokenize('	def self.hogefuga(hoge, foo)')
    result[:def].should == "def"
    result[:names].should == "hogefuga"
    result[:args].should == "(hoge, foo)"
    result[:pre_first_str].should == "	def self."
  end
  
  it "should tokenize '	def open(hoge, foo)'" do
    line = "	def open(hoge, foo)"
    @token.tokenize(line)[:def].should == "def"
    @token.tokenize(line)[:pre_first_str].should == "	def "
    @token.tokenize(line)[:names].should == ["open"]
    @token.tokenize(line)[:args].should == "(hoge, foo)"
  end
  
  it "should tokenize 'module Hoge::Hogeogeoge'" do
    line = 'module Hoge::Hogeogeoge'
    @token.tokenize(line)[:def].should == "module"
    @token.tokenize(line)[:pre_first_str].should == "module "
    @token.tokenize(line)[:names].should == ["Hoge", "Hogeogeoge"]
    @token.tokenize(line)[:args].should == ""
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