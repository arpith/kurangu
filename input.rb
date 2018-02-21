require 'rdl'
require 'types/core'

class Test
  extend RDL::Annotate
  type '(Fixnum or String, Fixnum or String) -> Fixnum or String'

  def plus(a, b)
    return a + b
  end

  extend RDL::Annotate
  type '(Fixnum or String, Fixnum or String) -> Fixnum or String or Fixnum or String'
  def first(a, b)
    return a
  end
end

t = Test.new
t.plus(1, 2)
t.plus('1', '3')
t.first(1, 3)
t.first('a', 'b')
