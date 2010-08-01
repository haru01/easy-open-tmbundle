require File.dirname(__FILE__) + "/../../lib/easyopen/open_test_log_file"

set_trace_func lambda { |event, file, line ,id, binding, klass|
  if event == 'call'
    puts  a_herf(file, line, "#{klass} #{id}") + "<br/>"  #+ sub_link(" #{file}:#{line}:in") 
  end
}

describe "sub_link" do
  it "" do
    %w[a b c].map{|n| n.upcase }.should == %w[A B C]
  end
end