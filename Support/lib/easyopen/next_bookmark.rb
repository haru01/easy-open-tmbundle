require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

def next_bookmark
  bookmarks = EasyOpen::BookmarkRepository.load
  exit_if_bookmarks_is_empty bookmarks
  bookmarks = rotate_bookmarks(bookmarks)
  EasyOpen::BookmarkRepository.save bookmarks 
  include EasyOpen::UI
  go_to(bookmarks.last)
end

def exit_if_bookmarks_is_empty bookmarks
  if bookmarks.empty?
    puts "bookmarks is empty"
    exit
  end
end

def rotate_bookmarks(bookmarks)

  # TODO case "not found bookmark[:file]"
  # TODO case "found bookmark[:file], but not found bookmark[:line]"
  file = ENV['TM_FILEPATH']
  line = ENV['TM_LINE_NUMBER']
  bookmark = bookmarks.shift
  bookmarks << bookmark
  if (file == bookmark[:file] and line == bookmark[:line]) 
    bookmark = bookmarks.shift
    bookmarks << bookmark
  end
  return bookmarks
end

