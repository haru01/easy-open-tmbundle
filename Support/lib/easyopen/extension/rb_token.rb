module EasyOpen
  module Extension
    class RbToken
      def tokenize(line)
        # class def module
        if m = /(^\s*(class|def|module)\s*)([\w:\.]*)(.*)$/.match(line)
          if mm = m[3].match(/([^\.]+)\.([^\.]+)/) # static method
            name = mm[2]
            return { :column => (m[1] + mm[1]).size + 2,
              :name => name,
              :more_info => line }
          else
            names = m[3].split("::")
            pre_first_str = m[1]
            colum = pre_first_str.size + 1

            return names.map do |name|
              current = colum
              colum += name.size + "::".size
              { :name => name,
                :column => current,
                :more_info => line }
            end.last
          end
        end
        if m = /^(\s*)([_A-Z0-9]+)\s*=\s*.*$/.match(line)
          return {
            :column => (m[1].size) + 1,
            :name => m[2],
            :more_info => line }
        end
        # alias_method, aliase_attribute, belongs_to, has_many, attr_reader, attr_accessor
        if m =/(^\s*(alias_method|alias_attribute|belongs_to|has_many|attr_reader|attr_accessor|alias)[\s:]*)([\w]*)(.*)$/.match(line)
          return {
            :column => (m[1].size) + 1,
            :name => m[3],
            :more_info => line }
        end
        # rspec 'let(:parent_group_metadata)'
        if m =/(^\s*let\(:)(\w*)\).*$/.match(line)
          return {
            :column => (m[1].size) + 1,
            :name => m[2],
            :more_info => line }
        end
      end
    end
  end
end
