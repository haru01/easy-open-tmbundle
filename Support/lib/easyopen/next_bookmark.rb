require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'

def next_bookmark
  bookmarks = EasyOpen::BookmarkRepository.load
  exit_if_bookmarks_is_empty bookmarks
  bookmarks = rotate_bookmarks(bookmarks)
  exit_if_bookmarks_is_empty bookmarks
  include EasyOpen::UI
  go_to(bookmarks.last)
  EasyOpen::BookmarkRepository.save bookmarks 
end

def exit_if_bookmarks_is_empty bookmarks
  if bookmarks.empty?
    puts "bookmarks is empty"
    exit
  end
end

def rotate_bookmarks(bookmarks, file = ENV['TM_FILEPATH'], line = ENV['TM_LINE_NUMBER'])
  while bookmarks.any?
    bookmark = bookmarks.shift
    if file == bookmark[:file] and line == bookmark[:line]
      bookmarks << bookmark
      bookmark = bookmarks.shift
    end
    if File.exist?(bookmark[:file])
      bookmarks << bookmark
      if bookmarks.last[:line].to_i > open(bookmarks.last[:file]).read.count("\n") + 1
        bookmarks.delete bookmarks.last
      else
        break
      end
    end
  end
  return bookmarks
end