require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"

module EasyOpen
  module UI
    def open_menu(infos)
      if infos.size == 0
        puts "not found path"
        return
      end
      
      if infos.size == 1
        TextMate.go_to(infos[0]) 
        return infos[0]
      end
      
      displays = infos.map { |info| info[:display] }
      selected  = TextMate::UI.menu(displays)
      return unless selected
      TextMate.go_to(infos[selected])
      return infos[selected]
    end
  end
end