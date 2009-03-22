require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'
require "pp"

file = ENV['TM_FILEPATH']
line = ENV['TM_LINE_NUMBER']

begin
  bookmarks = EasyOpen::BookmarkRepository.load
rescue
end
bookmarks ||= []
bookmarks.compact!

selected = bookmarks.select{ |node|
  node[:file] == file and node[:line] == line
}
if (selected.empty?)
  bookmarks.insert(0, {:file=>file, :line=>line})
  puts "add bookmark"
else
  bookmarks.delete_if { |node|
    node[:file] == file and node[:line] == line
  }
  puts "remove bookmark"
end
EasyOpen::BookmarkRepository.save bookmarks
