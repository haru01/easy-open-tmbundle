module EasyOpen
  class Config
    class << self
      def defaults
        save_dir = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}"
        @defaults ||= {
          :project_dir      =>  ENV["TM_PROJECT_DIRECTORY"],
          :current_word     =>  ENV['TM_CURRENT_WORD'],
          :save_dir         => save_dir,
          :def_location_dump => "#{save_dir}/def_location.dump",
          :call_stack_dump    => "#{save_dir}/call_stack.dump",
          :current_location => {:file => ENV["TM_FILEPATH"], :line => ENV["TM_LINE_NUMBER"], :column => ENV["TM_COLUMN_NUMBER"]},
          :current_file     => ENV['TM_FILEPATH']
        }
      end

      def setup(settings = {})
        @configuration = defaults.merge(settings)
      end

      def [](key)
        (@configuration ||= defaults)[key]
      end
    end
  end
end