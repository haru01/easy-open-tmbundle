require File.dirname(__FILE__) + "/ruby_token"
require File.dirname(__FILE__) + "/javascript_token"


module EasyOpen
  module Extension
    class UserConf
      def self.tokens
        { 
          "rb" => RubyToken.new,
          "js" => JavaScriptToken.new,
        }
      end
    end
  end
end