module EasyOpen
  module Extension
    class JavaScriptToken
      def tokenize(line)
        if m = /^(\s*([^\s]*))\s*=\s*function\s*(\(.*\)).*\{.*$/.match(line)
          name = m[2].split(".").last
          pre = m[1].sub(/#{Regexp.escape("#{name}")}$/, "")
        
          { :name => m[1].split(".").last,
            :column => pre.size + 1,
            :more_info => line }
        elsif m = /^([\s]*)(.*):\s*function.*$/.match(line)
        
          { :name => m[2],
            :column => m[1].size + 1,
            :more_info => line }
        elsif m = /^(\s*function\s*)(.*)\s*\(.*$/.match(line)
          
          { :name => m[2],
            :column => m[1].size + 1,
            :more_info => line }
        elsif m = /^([\s]*)(.*):\s*\{\s*$/.match(line)
          
          { :name => m[2],
            :column => m[1].size + 1,
            :more_info => line }
        end
      end
    end
  end
end