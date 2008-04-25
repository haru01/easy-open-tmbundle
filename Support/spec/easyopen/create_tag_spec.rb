require "pp"
require "yaml"
require File.dirname(__FILE__) + "/../../lib/easyopen/create_tag"

module EasyOpen
  module Tag
    
    describe YamlConverter do
      before(:all) do
        @converter = YamlConverter.new
        @yaml = nil
        file_name = File.expand_path(File.dirname(__FILE__)) + '/../../fixtures/ruby_code.rb'
          # test target method
        File.open(file_name){ |file| @converter.parse(file) }
        
        @yaml = @converter.to_yaml
        @result = YAML.load(@yaml)
      end
      
      it "ハッシュ:filesにファイルの位置情報が含まれていること" do
        @result[:files].should include("/Users/ienagaeiji/Library/Application Support/TextMate/Bundles/EasyOpen.tmbundle/Support/fixtures/ruby_code.rb")
      end
      
      it "ハッシュ：locationsに複数のロケーション情報が含まれていること" do
        require 'pp'
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