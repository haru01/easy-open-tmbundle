
class 
  def hoge_hoge
  end
  
  def hoge
  end
  
  def hoge(arg1, arg2)
  end
  
  def open(hoge)
  end
end

class Fuga < Object; end

module Foo
  class Foo
    def hoge(param1, param2)
    end
    def foo(hoge, &block); end
  end
end

module Hoge::Fuga
end

#  def hogeoge