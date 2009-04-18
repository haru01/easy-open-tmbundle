require File.dirname(__FILE__) + '/ui'

word = ENV["TM_CURRENT_WORD"]
filepath = ENV["TM_FILEPATH"]
line_n = ENV["TM_LINE_NUMBER"].to_i
column = ENV["TM_COLUMN_NUMBER"].to_i

go_to_line_num = nil
go_to_clumn_num = nil

File.open(filepath) do |file|
  file.each_with_index do |line_str, index|
    row = index + 1
    start_search_column = 0
    if line_n <=  row
      start_search_column = column if line_n == row
      if column_index = line_str.index(word, start_search_column)
        go_to_line_num = row
        go_to_clumn_num = column_index + 1
        break
      end
    end
  end
end
  
unless go_to_clumn_num
  File.open(filepath) do |file|
    # puts "from first search"
    file.each_with_index do |line_str, index|
      row = index + 1
      start_search_column = column
      if column_index = line_str.index(word, 0)
        go_to_line_num = row
        go_to_clumn_num = column_index + 1
        break
      end
    end
  end
end

if go_to_clumn_num and go_to_line_num
  params = { :file    => filepath,
             :line    => go_to_line_num,
             :column  => go_to_clumn_num}
  include EasyOpen::UI
  go_to params
end
