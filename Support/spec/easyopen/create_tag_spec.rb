require "pp"

require File.dirname(__FILE__) + "/../../lib/easyopen/create_def_location_data"

module EasyOpen
  module Tag
    
    describe "メソッドなどの位置情報のデータ構造について" do
      before(:all) do
        @visitor = FileVisitor.new
        file_name = File.expand_path(File.dirname(__FILE__)) + '/../../fixtures/ruby_code.rb'
          # test target method
        File.open(file_name){ |file| @visitor.visit(file) }
        @result = @visitor.create_def_location_data
      end
      
      it "ハッシュ:filesにファイルの位置情報が含まれていること" do
        @result[:files].should include("/Users/ienagaeiji/Library/Application Support/TextMate/Bundles/EasyOpen.tmbundle/Support/fixtures/ruby_code.rb")
      end
      
      it "ハッシュ：locationsに複数のロケーション情報が含まれていること" do
        pp @result[:name_locationids]
        @result[:locations].size.should eql(11)
      end

      it "ハッシュ：locationsの一要素にファイルを開くためのロケーション情報（:line, :file_id)が含まれていること" do
        @result[:locations][0][:line].should eql(2)
        @result[:locations][0][:file_id].should eql(0)        
      end

      it "ハッシュ:name_locationidsに名前をキーに複数のlocationsのインデックス情報が含まれていること" do
        @result[:name_locationids]["hoge"].should_not eql(nil)
        @result[:name_locationids]["hoge"].size.should eql(3)
      end
    end
  end
end