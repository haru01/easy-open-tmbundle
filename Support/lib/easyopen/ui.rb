require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"

module EasyOpen
  module UI
    def open_menu(infos)
      puts "not found path" if infos.size == 0
      
      if infos.size == 1
        TextMate.go_to(infos[0]) 
        return
      end
      
      displays = infos.map { |info| info[:display] }
      selected  = TextMate::UI.menu(displays)
      return unless selected
      TextMate.go_to(infos[selected])
    end
  end
end