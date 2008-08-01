require "pp"

require File.dirname(__FILE__) + "/../../lib/easyopen/create_def_index_file"

module EasyOpen
  describe "メソッドなどの位置情報のデータ構造について" do
    before(:all) do
      @parser = Parser.new
      @file_name = File.expand_path(File.dirname(__FILE__)) + '/../../fixtures/ruby_code.rb'
        # test target method
      @parser.parse(@file_name)
      @result = @parser.def_index
    end
    
    it "ハッシュ:filesにファイルの位置情報が含まれていること" do
      @result[:files].should include(@file_name)
    end
    
    it "ハッシュ：locationsに複数のロケーション情報が含まれていること" do
      @result[:locations].should have_at_least(11).items
    end

    it "ハッシュ：locationsの一要素にファイルを開くためのロケーション情報（:line, :file_id)が含まれていること" do
      @result[:locations][0][:file_id].should eql(0)        
    end

    it "ハッシュ:name_locationidsに名前をキーに複数のlocationsのインデックス情報が含まれていること" do
      @result[:name_locationids]["hoge"].should_not eql(nil)
      @result[:name_locationids]["hoge"].size.should eql(3)
    end
  end
  
  describe Token do
    before(:each) do
      @token = Token.new
    end
    
    it "should tokenize '	def self.hogefuga(hoge, foo)'" do
      result = @token.tokenize('	def self.hogefuga(hoge, foo)')
      result[:def].should == "def"
      result[:names].should == "hogefuga"
      result[:args].should == "(hoge, foo)"
      result[:pre_first_name].should == "	def self."
    end
    
    it "should tokenize '	def open(hoge, foo)'" do
      line = "	def open(hoge, foo)"
      @token.tokenize(line)[:def].should == "def"
      @token.tokenize(line)[:pre_first_name].should == "	def "
      @token.tokenize(line)[:names].should == ["open"]
      @token.tokenize(line)[:args].should == "(hoge, foo)"
    end
    
    it "should tokenize 'module Hoge::Hogeogeoge'" do
      line = 'module Hoge::Hogeogeoge'
      @token.tokenize(line)[:def].should == "module"
      @token.tokenize(line)[:pre_first_name].should == "module "
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
end