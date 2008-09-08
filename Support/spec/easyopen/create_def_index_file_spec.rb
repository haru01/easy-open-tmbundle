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

    it "ハッシュ:name_locationIdsに名前をキーに複数のlocationsのインデックス情報が含まれていること" do
      @result[:name_locationIds]["hoge"].should_not eql(nil)
      @result[:name_locationIds]["hoge"].size.should eql(3)
    end
  end
end