require File.dirname(__FILE__) + '/ui'
require File.dirname(__FILE__) + '/config'
require "yaml"


bookmark_file = EasyOpen::Config[:bookmark_file]
unless File.exist?(bookmark_file)
  puts "Not found bookmark.file => #{bookmark_file}"
  exit
end
bookmarks = File.open(bookmark_file) {|ym|
  YAML.load(ym)
}
include EasyOpen::UI
bookmark=bookmarks.shift
bookmarks << bookmark
File.open(bookmark_file, "w") {|out|
  YAML.dump(bookmarks, out)
}
unless bookmark
  puts "bookmark is nil"
  exit
end
go_to(bookmark)