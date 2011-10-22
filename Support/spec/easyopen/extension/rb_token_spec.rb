require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/rb_token"
require File.dirname(__FILE__) + "/spec_helper"

module EasyOpen::Extension
  describe "RbToken#tokeninze" do

    def sbjct input_line
      RbToken.new.tokenize(input_line)
    end

    it "tokeinze '  HOGE2 = 2'" do
      line = '  HOGE_2 = 1'
      sbjct(line).should eq_token({
            :name  => "HOGE_2",
            :column => "  ".size + 1,
            :more_info => line})

    end

    it "tokeinze '  has_many :name'" do
      line = '  has_many :name'
      sbjct(line).should eq_token({
            :name  => "name",
            :column => "  has_many :".size + 1,
            :more_info => line})
    end

    it "tokeinze '  belongs_to :name'" do
      line = '  belongs_to :name'
      sbjct(line).should eq_token({
            :name  => "name",
            :column => "  belongs_to :".size + 1,
            :more_info => line})
    end

    it "tokeinze '  alias_attribute :alias_name, :collumn_name'" do
      line = '  alias_attribute :alias_name, :collumn_name'
      sbjct(line).should eq_token({
            :name  => "alias_name",
            :column => "  alias_attribute :".size + 1,
            :more_info => line})
    end

    it "tokenize 'alias_method :abort, :conclude'" do
      line = '    alias_method :abort, :conclude'
      sbjct(line).should eq_token({
            :name  => "abort",
            :column => '    alias_method :'.size + 1,
            :more_info => line})
    end


    it "tokenize '    def Parse.html_to_text s'" do
      line = '    def Parse.html_to_text s'
      sbjct(line).should eq_token({
            :name  => "html_to_text",
            :column => "    def Parse.".size + 1,
            :more_info => line})
    end

    it "tokenize '  def self.hogefuga(hoge, foo)'" do
      line = '  def self.hogefuga(hoge, foo)'
      sbjct(line).should eq_token({
            :name  => "hogefuga",
            :column => "  def self.".size + 1,
            :more_info => line})
    end

    it "tokenize '  def open(hoge, foo)'" do
      line = "  def open(hoge, foo)"
      sbjct(line).should eq_token({
            :name  => "open",
            :column => "  def ".size + 1,
            :more_info => line})
    end

    it "tokenize 'module Hoge::Hogeogeoge'" do
      line = 'module Hoge::Hogeogeoge'
      sbjct(line).should eq_token({
            :name  => "Hogeogeoge",
            :column => "module Hoge::".size + 1,
            :more_info => line})
    end

    it "tokenize 'let(:parent_group_metadata)'" do
      line = '    let(:parent_group_line_number) { parent_group_metadata[:example_group][:line_number] }'
      sbjct(line).should eq_token({
            :name  => "parent_group_line_number",
            :column => '    let(:)'.size,
            :more_info => line})
    end

    it "return nil if not include def module class" do
      line = '      '
      sbjct(line).should be_nil
    end

    it "return nil if comment def module class" do
      line = ' # def hoge'
      sbjct(line).should be_nil
    end
  end
end