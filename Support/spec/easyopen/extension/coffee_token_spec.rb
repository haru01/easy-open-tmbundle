require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/coffee_token"

module EasyOpen::Extension
  describe CoffeeToken do
    before(:each) do
      @coffee = CoffeeToken.new
    end

    it "should token 'hoge: 8" do
      line = "hoge: 8"
      result = @coffee.tokenize(line)
      result[:name].should == "hoge"
      result[:column].should == "".size + 1
      result[:more_info].should == line
    end
    
    it "should token 'award_medals: (first, second, rest...) ->'" do
      line = "award_medals: (first, second, rest...) ->"
      result = @coffee.tokenize(line)
      result[:name].should == "award_medals"
      result[:column].should == "".size + 1
      result[:more_info].should == line
    end

    it "should token '  award_medals: (first, second, rest...) ->'" do
      line = "  award_medals: (first, second, rest...) ->"
      result = @coffee.tokenize(line)
      result[:name].should == "award_medals"
      result[:column].should == "  ".size + 1
      result[:more_info].should == line
    end
    
    it "should token 'class Horse extends Animal'" do
      line = "class Horse extends Animal"
      result = @coffee.tokenize(line)
      result[:name].should == "Horse"
      result[:column].should == "class ".size + 1
      result[:more_info].should == line
    end
  end
end
