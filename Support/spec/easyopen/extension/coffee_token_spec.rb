require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/coffee_token"
require File.dirname(__FILE__) + "/spec_helper"

module EasyOpen::Extension
  describe "CoffeeToken#tokenize" do
    
    def sbjct line
      CoffeeToken.new.tokenize(line)
    end

    it "token 'hoge: 8" do
      line = "hoge: 8"
      sbjct(line).should eq_token({
                :name  => "hoge", 
                :column => 1, 
                :more_info => line})
      
    end
    
    it "token 'award_medals: (first, second, rest...) ->'" do
      line = "award_medals: (first, second, rest...) ->"
      sbjct(line).should eq_token({
                :name  => "award_medals", 
                :column => 1, 
                :more_info => line})
    end

    it "token '  award_medals: (first, second, rest...) ->'" do
      line = "  award_medals: (first, second, rest...) ->"
      sbjct(line).should eq_token({
                :name  => "award_medals", 
                :column => "  ".size + 1, 
                :more_info => line})
    end
    
    it "token 'class Horse extends Animal'" do
      line = "class Horse extends Animal"
      sbjct(line).should eq_token({
                :name  => "Horse", 
                :column => "class ".size + 1, 
                :more_info => line})
    end
  end
end
