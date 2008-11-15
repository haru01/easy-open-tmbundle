module EasyOpen
  module Extension
    class JavaToken
      def tokenize(line)
        # interface
        if m = /(^.*interface\s*)(\w*)[\s|{]*/.match(line)
          pre = m[1]
          return { 
            :name => m[2],
            :column => pre.size + 1,
            :more_info => line }
        # class
        elsif m = /(^.*class\s*)(\w*)[\s|{]*/.match(line)
            pre = m[1]
            return { 
              :name => m[2],
              :column => pre.size + 1,
              :more_info => line }        
        # method        
        elsif m = /(^.*\s)(\w*)\(.*\)[^;]*$/.match(line)
          pre = m[1]
          return { 
            :name => m[2],
            :column => pre.size + 1,
            :more_info => line }        
        else
          # ignore
        end
      end
    end
  end
end