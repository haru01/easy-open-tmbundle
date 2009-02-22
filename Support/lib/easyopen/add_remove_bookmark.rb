require File.dirname(__FILE__) + '/config'
require "yaml"
require "pp"

bookmark_file = EasyOpen::Config[:bookmark_file]
file = ENV['TM_FILEPATH']
line = ENV['TM_LINE_NUMBER']

if File.exist?(bookmark_file)
  bookmarks = File.open(bookmark_file) {|yf| YAML.load(yf)}
end
bookmarks ||= []
bookmarks.compact!

selected = bookmarks.select{|node|
  node[:file] == file and node[:line] == line
}
if (selected.empty?)
  bookmarks.insert(0, {:file=>file, :line=>line})
  puts "add bookmark"
  # puts "file:#{file}"
  # puts "line:#{line}"
else
  bookmarks.delete_if {|node|
    node[:file] == file and node[:line] == line
  }
  puts "remove bookmark"
  # puts "file:#{file}"
  # puts "line:#{line}"
end
File.open(bookmark_file,"w") {|out|
  YAML.dump(bookmarks, out)
}