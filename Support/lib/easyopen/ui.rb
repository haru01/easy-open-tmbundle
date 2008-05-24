require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"

module EasyOpen
  module UI
    def open_menu(infos)
      infos = [infos].flatten
      if infos.size == 0
        puts "not found"
        return
      end
      
      if infos.size == 1
        go_to(infos[0]) 
        return infos[0]
      end
      
      displays = infos.map { |info| info[:display] }
      selected  = TextMate::UI.menu(displays)
      return unless selected
      go_to(infos[selected])
      return infos[selected]
    end
    
    def go_to(options = {})
      ri = "txmt://open?url=file://#{e_url options[:file]}"
      ri = ri + "&line=#{options[:line]}" if options[:line]
      ri = ri + "&column=#{options[:column]}" if options[:column]
      `open "#{ri}"`
    end
  end
end