require File.dirname(__FILE__) + '/config'

module EasyOpen
  class CallStackRepository
    class << self
      def init
        open("#{Config[:call_stack_dump]}", "w") { |mio|
          Marshal.dump([], mio)
        }
      end
      
      def save(call_stack)
        open("#{Config[:call_stack_dump]}", "w") { |mio|
          Marshal.dump(call_stack, mio)
        }
      end
      
      def load
        open("#{Config[:call_stack_dump]}", "r") { |io|
          Marshal.load(io)        
        }
      end
    end
  end
  
  class DefDataRepository
    class << self
      def save(def_data)
        open("#{Config[:def_location_dump]}", "w") { |mio|
          Marshal.dump(def_data, mio)
        }
      end
      
      def load
        begin
          def_location_data = nil
          open("#{Config[:def_location_dump]}", "r") { |io|
            def_location_data = Marshal.load(io)
          }
          return def_location_data
        rescue
          puts "not found def_location_data file. please create_def_location_data_file before open_def"
          exit
        end      
      end
    end
  end
end