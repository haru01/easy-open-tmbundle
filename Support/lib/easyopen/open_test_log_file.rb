def open_log(log_file)
  filterd_lines = []
  prev_line = nil
  File.open(log_file) do |file|
    file.each do |line|
      filterd_lines <<  sub_link(line)      
    end
  end
  filterd_lines
end

def sub_link(line)
  regs = [/called from new at (([^:]*):(\d+))/, /^\s*(([^:]*):(\d+):in)/]
  regs.each do |reg|
    if m = reg.match(line)
      url = m[2].gsub(/^\.\//, "#{ENV['TM_PROJECT_DIRECTORY']}/")
      url = url.gsub(/^\.\.\//, "/")
      line = line.sub(m[1], a_herf(url, m[3], "#{url}:#{m[3]}")) + "<br/>"
    end
  end
  line = line.gsub(/\n/, "<br/>")
  line = line.gsub(/^\s/, "&nbsp;")
end

def a_herf(url, line, display)
  %Q+<Font Size="4" Color="#0000ff"><a href="txmt://open?url=file://#{url}&line=#{line}">#{display}</a></Font>+
end

# line ="DEPRECATION WARNING: Giving :session_key to SessionStore is deprecated, please use :key instead. (called from new at /Library/Ruby/Gems/1.8/gems/actionpack-2.3.8/lib/action_controller/middleware_stack.rb:72)"
# m = /called from new at ([^:]*):(\d+)/.match(line)
# puts m[1]
# puts m[2] /Library/Ruby/Gems/1.8/gems/actionpack-2.3.8/lib/action_controller/middleware_stack.rb
# 72
