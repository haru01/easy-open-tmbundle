require File.dirname(__FILE__) + "/ruby_token"
require File.dirname(__FILE__) + "/javascript_token"
require File.dirname(__FILE__) + "/java_token"
require File.dirname(__FILE__) + "/coffee_token"


module EasyOpen
  module Extension
    class UserConf
      def self.tokens
        { 
          "rb" => RubyToken.new,
          "js" => JavaScriptToken.new,
          "java" => JavaToken.new,
          "coffee" => CoffeeToken.new
        }
      end
    end
  end
end