require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/ruby_token"

module EasyOpen::Extension
  describe RubyToken do
    before(:each) do
      @token = RubyToken.new
    end
  
    it "should tokenize '	def self.hogefuga(hoge, foo)'" do
      line = '	def self.hogefuga(hoge, foo)'
      result = @token.tokenize(line)
      result[:name].should == "hogefuga"
      result[:column].should == "	def self.".size + 1
      result[:more_info].should == line
    end
  
    it "should tokenize '	def open(hoge, foo)'" do
      line = "	def open(hoge, foo)"
      result = @token.tokenize(line)
      result[:name].should == "open"
      result[:column].should == "	def ".size + 1
      result[:name].should == "open"
    end
  
    it "should tokenize 'module Hoge::Hogeogeoge'" do
      line = 'module Hoge::Hogeogeoge'
      result = @token.tokenize(line)
      result[:column].should == "module Hoge::".size + 1
      result[:name].should == "Hogeogeoge"
      result[:more_info].should == line
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