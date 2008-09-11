module EasyOpen
  module Extension
    class JavaScriptToken
      def tokenize(line)
        if m = /^([^\s]*)\s*=\s*function\s*(\(.*\)).*\{.*$/.match(line)
          name = m[1].split(".").last
          tmp = m[1].split(".")
          tmp.pop
          pre = tmp.join(".")
          pre += "."
        
          [{ :name => m[1].split(".").last,
             :column => pre.size + 1,
             :more_info => line },
          ]
        elsif m = /^([\s]*)(.*):\s*function.*$/.match(line)
        
          [{ :name => m[2],
             :column => m[1].size + 1,
             :more_info => line },
          ]
        end
      end
    end
  end
end