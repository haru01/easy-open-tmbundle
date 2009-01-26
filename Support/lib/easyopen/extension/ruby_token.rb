module EasyOpen
  module Extension
    class RubyToken
      def tokenize(line)
        if m = /(^\s*(class|def|module)\s*)([\w:\.]*)(.*)$/.match(line)
          if mm = m[3].match(/([^\.]+)\.([^\.]+)/) # static method
            name = mm[2]
            { :column => (m[1] + mm[1]).size + 2,
              :name => name,
              :more_info => line }
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
            end.last
          end
        end
      end
    end
  end
end