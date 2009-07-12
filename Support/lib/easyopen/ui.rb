require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"

module EasyOpen
  module UI
    def open_menu_must_list_show infos
      open_menu(infos, true)
    end
    
    def open_menu(infos, size_one_show = false)
      infos = [infos].flatten
      if infos.size == 0
        puts "not found"
        return
      end
      
      if infos.size == 1 && !size_one_show
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
      resource_identifier = "txmt://open?url=file://#{e_url options[:file]}"
      resource_identifier = resource_identifier + "&line=#{options[:line]}" if options[:line]
      resource_identifier = resource_identifier + "&column=#{options[:column]}" if options[:column]
      `open "#{resource_identifier}"`
    end
  end
end