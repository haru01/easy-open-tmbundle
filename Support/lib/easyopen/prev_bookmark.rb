require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

file = ENV['TM_FILEPATH']
line = ENV['TM_LINE_NUMBER']

bookmarks = bookmarks = EasyOpen::BookmarkRepository.load

bookmark = bookmarks.pop
bookmarks.insert(0, bookmark)
if (file == bookmark[:file] and line == bookmark[:line]) 
  bookmark = bookmarks.pop
  bookmarks.insert(0, bookmark)
end

EasyOpen::BookmarkRepository.save bookmarks 
unless bookmark
  puts "bookmark is nil"
  exit
end

include EasyOpen::UI
go_to(bookmark)