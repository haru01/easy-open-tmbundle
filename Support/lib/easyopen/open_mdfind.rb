require "#{ENV["TM_SUPPORT_PATH"]}/lib/ui"
require "#{ENV['TM_SUPPORT_PATH']}/lib/textmate"


def a_herf(url)
  %Q+<Font Size="3" Color="#0000ff"><a href="txmt://open?url=file://#{url}">#{url}</a></Font><br/>+
end

TextMate::UI.request_string do |keyword|
  paths = `mdfind #{keyword}`
  paths.split("\n").each do|path|
    puts a_herf(path)
  end
end

