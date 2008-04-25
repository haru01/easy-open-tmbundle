require 'open-uri'

def find_alc(word=ENV["TM_CURRENT_WORD"])
  url = "http://eow.alc.co.jp/#{word}/UTF-8"
  open(url) {|f| f.read }
end

puts find_alc