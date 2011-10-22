require File.dirname(__FILE__) + '/context'
require File.dirname(__FILE__) + '/repository'
require "pp"

file = ENV['TM_FILEPATH']
line = ENV['TM_LINE_NUMBER']

bookmarks = []
bookmarks = EasyOpen::BookmarkRepository.load if File.exist?(EasyOpen::Context[:bookmark_file])

selected = bookmarks.select{ |node| node[:file] == file and node[:line] == line }

if (selected.empty?)
  bookmarks.insert(0, {:file=>file, :line=>line})
  puts "add bookmark[#{File.basename(file)}:#{line}]"
  puts "if press again then remve bookmark"
else
  bookmarks.delete_if { |node|
    node[:file] == file and node[:line] == line
  }
  puts "remove bookmark"
end

EasyOpen::BookmarkRepository.save bookmarks
