module EasyOpen
  class Config
    class << self
      def defaults
        save_dir = "#{ENV["HOME"]}/.easyopen_tmbundle#{ENV["TM_PROJECT_DIRECTORY"]}"
        
        @defaults ||= {
          :project_dir        =>  ENV["TM_PROJECT_DIRECTORY"],
          :current_word       =>  ENV['TM_CURRENT_WORD'],
          :save_dir           => save_dir,
          :def_index_file     => "#{save_dir}/def_index.dump",
          :call_stack_file    => "#{save_dir}/call_stack.dump",
          :bookmark_file     => "#{save_dir}/bookmark.yaml",
          :current_file       => ENV['TM_FILEPATH']
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