require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/rb_token"

module EasyOpen::Extension
  describe RbToken do
    before(:each) do
      @token = RbToken.new
    end
    
    it "should tokeinze '  HOGE2 = 2'" do
      line = '  HOGE_2 = 1'
      result = @token.tokenize(line)
      result[:name].should == "HOGE_2"
      result[:column].should == "  ".size + 1
      result[:more_info].should == line
    end
    
    it "should tokeinze '  has_many :name'" do
      line = '  has_many :name'
      result = @token.tokenize(line)
      result[:name].should == "name"
      result[:column].should == "  has_many :".size + 1
      result[:more_info].should == line
    end

    it "should tokeinze '  belongs_to :name'" do
      line = '  belongs_to :name'
      result = @token.tokenize(line)
      result[:name].should == "name"
      result[:column].should == "  belongs_to :".size + 1
      result[:more_info].should == line
    end    
    
    it "should tokeinze '  alias_attribute :alias_name, :collumn_name'" do
      line = '  alias_attribute :alias_name, :collumn_name'
      result = @token.tokenize(line)
      result[:name].should == "alias_name"
      result[:column].should == "  alias_attribute :".size + 1
      result[:more_info].should == line
    end
    
    it "should tokenize '    def Parse.html_to_text s'" do
      line = '    def Parse.html_to_text s'
      result = @token.tokenize(line)
      result[:name].should == "html_to_text"
      result[:column].should == "    def Parse.".size + 1
      result[:more_info].should == line
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