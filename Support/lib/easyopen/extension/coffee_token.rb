module EasyOpen
  module Extension
    class CoffeeToken
      def tokenize(line)
        if m = /(^\s*)(\w*):.*$/.match(line)
          pre = m[1]
          return { 
            :name => m[2],
            :column => pre.size + 1,
            :more_info => line }
        elsif m = /(^\s*class\s*)(\w*)(.*)$/.match(line)
          pre = m[1]
          return { 
            :name => m[2],
            :column => pre.size + 1,
            :more_info => line }       
        end
      end
    end
  end
end