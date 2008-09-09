module EasyOpen
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

  class RubyToken
    def tokenize(line)
      if m = /(^\s*(class|def|module)\s*)([\w:\.]*)(.*)$/.match(line)
        if m[3].include?("self.")
          name = m[3].gsub("self.", "")
          pre_first_str = m[1] + "self."
          
          [{ :column => pre_first_str.size + 1,
             :name => name,
             :more_info => line },]
        else
          names = m[3].split("::")
          pre_first_str = m[1]
          colum = pre_first_str.size + 1
          
          names.map do |name|
            current = colum
            colum += name.size + "::".size
            { :name => name,
              :column => current,
              :more_info => line }
          end
        end
      end
    end
  end
end