require File.dirname(__FILE__) + '/config'
require "yaml"

bookmark_file = EasyOpen::Config[:bookmark_file]
bookmarks = []
if File.exist?(bookmark_file)
  bookmarks = File.open(bookmark_file) {|yf| YAML.load(yf)}
end
bookmarks.insert(0, {:file=>ENV['TM_FILEPATH'], :line=>ENV['TM_LINE_NUMBER']})
File.open(bookmark_file,"w") {|out|
  YAML.dump(bookmarks, out)
}