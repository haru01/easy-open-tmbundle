
module EasyOpen
  module Extension
    class UserConf
      @@exts = {}
      Dir.glob("#{File.dirname(__FILE__)}/*").each do |file_name|
        require file_name
        basename = File.basename(file_name)
        unless basename == "user_conf.rb"
          tmp = basename.sub("_token.rb", "") 
          # puts tmp
          @@exts[tmp] = eval("#{tmp[0..0].upcase}#{tmp[1..-1]}Token.new")
        end
      end
      def self.tokens
        @@exts
      end
    end
  end
end