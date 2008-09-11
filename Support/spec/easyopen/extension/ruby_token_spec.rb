require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/ruby_token"

module EasyOpen::Extension
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