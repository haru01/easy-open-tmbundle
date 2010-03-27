module EasyOpen
  module Extension
    class JsToken
      def tokenize(line)
        # ex: SSpec.Executor = function
        # ex:   to = function(matcher) {
        if m = /^(\s*([^\s]*))\s*=\s*function\s*(\(.*\)).*\{.*$/.match(line)
          name = m[2].split(".").last
          pre = m[1].sub(/#{Regexp.escape("#{name}")}$/, "")
        
          { :name => m[1].split(".").last.strip,
            :column => pre.size + 1,
            :more_info => line }
        
        # assert.ok = function ok
        elsif m = /^(\s*[^\s]*\s*=\s*function\s*)([^\s]*)\s*\(.*$/.match(line)
          { :name => m[2],
            :column => m[1].size + 1,
            :more_info => line }

        # ex: ' grep: function(filter, iterator, context) {'
        elsif m = /^([\s]*)(\S*)\s*:\s*function.*$/.match(line)
        
          { :name => m[2],
            :column => m[1].size + 1,
            :more_info => line }
            
        # ex: 'function makeBlock (f) {'
        elsif m = /^(\s*function\s*)([^\s]*)\s*\(.*$/.match(line)
          
          { :name => m[2],
            :column => m[1].size + 1,
            :more_info => line }
        # ex: ' be_empty: {'
        elsif m = /^([\s]*)(.*):\s*\{\s*$/.match(line)
          
          { :name => m[2],
            :column => m[1].size + 1,
            :more_info => line }
        end
      end
    end
  end
end

