module EasyOpen
  module Extension
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
            # :: で区切った複数要素を探せるように配列を返しているが、
            #    もしかして最後の要素だけでよい？
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
end