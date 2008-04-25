def backtrace_link(backtrace_log)
  link = []
  prev_line = nil
  File.open(backtrace_log) do |file|
    file.each do |line|
      if m = /^\s+at line (\/.*):(\d+$)/.match(line) 
        link << a_herf("file://#{m[1]}", m[2], "#{prev_line}<li>#{m[1..2]}</li><br/>")
      end
      prev_line = line
    end
  end
  link
end

def a_herf(url, line, display)
  %Q+<Font Size="2" Color="#0000ff"><a href="txmt://open?url=#{url}&line=#{line}">#{display}</a></Font>+
end

puts backtrace_link("#{ENV["TM_PROJECT_DIRECTORY"]}/backtrace.log")
