module EasyOpen
  class JavaScriptToken
    def tokenize(line)
      if m = /^([^\s]*)\s*=\s*function\s*(\(.*\)).*\{.*$/.match(line)
        name = m[1].split(".").last
        tmp = m[1].split(".")
        tmp.pop
        pre = tmp.join(".")
        pre += "."
        {
          :names => m[1].split(".").last,
          :pre_first_str => pre
        }
      elsif m = /^([\s]*)(.*):\s*function.*$/.match(line)
        {
          :names => m[2],
          :pre_first_str => m[1]
        }
      end
    end
  end

  class RubyToken
    def tokenize(line)
      if m = /(^\s*(class|def|module)\s*)([\w:\.]*)(.*)$/.match(line)
        names = if m[3].include?("self.")
          m[3].gsub("self.", "")
        else
          m[3].split("::")
        end
      
        pre_first_str = m[1]
        pre_first_str += "self." if m[3].include?("self.")
      
        {
          :pre_first_str => pre_first_str,
          :names => names,
        }
      end
    end
  end
end