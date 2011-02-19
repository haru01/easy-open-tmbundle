require File.dirname(__FILE__) + '/config'
require File.dirname(__FILE__) + '/repository'
require File.dirname(__FILE__) + '/ui'



file = ENV['TM_FILEPATH']
line = ENV['TM_LINE_NUMBER']

unless File.exist?(EasyOpen::Config[:bookmark_file])
  puts "not found bookmark file"
  exit
end

bookmarks = EasyOpen::BookmarkRepository.load 

if bookmarks.nil? || bookmarks.empty?
  puts "empty bookmark"
  exit
end

bookmarks.each do |b|
  d = "#{File.basename(b[:file])}:#{b[:line]}"
  b.merge!({:display => d})
end


include EasyOpen::UI
open_menu bookmarks
