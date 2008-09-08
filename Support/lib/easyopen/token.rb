class JavaScriptToken
  def tokenize(line)
    if m = /^([^\s]*)\s*=\s*function(\(.*\)).*\{.*$/.match(line)
      name = m[1].split(".").last
      tmp = m[1].split(".")
      tmp.pop
      pre = tmp.join(".")
      pre += "."
      {
        :def => "function",
        :names => m[1].split(".").last,
        :args => m[2],
        :pre_first_str => pre
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
        :def => m[2],
        :pre_first_str => pre_first_str,
        :names => names,
        :args => m[4]
      }
    end
  end
end