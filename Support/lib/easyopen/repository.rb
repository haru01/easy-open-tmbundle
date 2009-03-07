require File.dirname(__FILE__) + '/config'
require "yaml"


module EasyOpen
  class CallStackRepository
    class << self
      def init
        open("#{Config[:call_stack_file]}", "w") { |mio|
          Marshal.dump([], mio)
        }
      end
      
      def save(call_stack)
        open("#{Config[:call_stack_file]}", "w") { |mio|
          Marshal.dump(call_stack, mio)
        }
      end
      
      def load
        begin
          open("#{Config[:call_stack_file]}", "r") { |io|
            Marshal.load(io)        
          }          
        rescue
          puts "not found call_stack file. please create_def_index_file"
          exit
        end
      end
    end
  end
  
  class DefIndexRepository
    class << self
      def save(def_index)
        open("#{Config[:def_index_file]}", "w") { |mio|
          Marshal.dump(def_index, mio)
        }
      end
      
      def load
        begin
          def_index = nil
          open("#{Config[:def_index_file]}", "r") { |io|
            def_index = Marshal.load(io)
          }
          return def_index
        rescue
          puts "not found def_index file. please create_def_index_file before open_def"
          exit
        end      
      end
    end
  end

  class BookmarkRepository
    class << self
      def save(bookmarks)
        bookmark_file = EasyOpen::Config[:bookmark_file]
        File.open(bookmark_file, "w") {|out|
          YAML.dump(bookmarks, out)
        }
      end
      
      def load
        bookmark_file = EasyOpen::Config[:bookmark_file]
        bookmarks = File.open(bookmark_file) {|ym|
          YAML.load(ym)
        }
        return bookmarks
      end
    end
  end
end