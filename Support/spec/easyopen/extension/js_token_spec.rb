require File.dirname(__FILE__) + "/../../../lib/easyopen/extension/js_token"
require File.dirname(__FILE__) + "/spec_helper"


module EasyOpen::Extension
  describe "JsToken#tokeninze" do    
    def sbjct line
      JsToken.new.tokenize(line)
    end
    
    it "tokinize '    color : function(string, color) {'" do
      line =  '    color : function(string, color) {'
      sbjct(line).should 
          eq_token({:name  => "color", 
                    :column => 4, 
                    :more_info => line})
    end
    
    it "tokenize '  be_empty: {'" do
      line =   '  be_empty: {'
      sbjct(line).should 
          eq_token({:name  => "be_empty", 
                    :column => "   ".size + 1, 
                    :more_info => line})
    end

    it "tokenize '  function define(self, name, fn) {'" do
      line =   '  function define(self, name, fn) {'
      sbjct(line).should 
          eq_token({:name  => "define", 
                    :column => "  function ".size + 1, 
                    :more_info => line})
    end

    it "tokenize 'function makeBlock (f) {'" do
      line =  'function makeBlock (f) {'
      sbjct(line).should 
          eq_token({:name  => "makeBlock", 
                    :column => "function ".size + 1,
                    :more_info => line})
    end
      
    it "tokeninze ' JSSpec.Executor = function(target, onSuccess, onException) {'" do
      line = ' JSSpec.Executor = function(target, onSuccess, onException) {'
      sbjct(line).should 
          eq_token({:name  => "Executor", 
                    :column => " JSSpec.".size + 1,
                    :more_info => line})
    end

    it "tokeninze '  to = function(matcher) {'" do
      line = '  to = function(matcher) {'
      sbjct(line).should 
          eq_token({:name  => "to", 
                    :column => "  ".size + 1,
                    :more_info => line})
    end
  
    it "tokenize '  grep: function(filter, iterator, context) {'" do
      line = '  grep: function(filter, iterator, context) {'
      sbjct(line).should 
          eq_token({:name  => "grep", 
                    :column => "  ".size + 1,
                    :more_info => line})
    end

    it "tokenize 'assert.ok = function ok(value, message) {'" do
      line = 'assert.ok = function ok(value, message) {'
      sbjct(line).should 
          eq_token({:name  => "ok", 
                    :column => "assert.ok = function ".size + 1,
                    :more_info => line})

    end
  end
end