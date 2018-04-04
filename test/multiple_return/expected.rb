require 'rdl'
require 'types/core'

extend RDL::Annotate
type Object, :the_answer, '(Fixnum x) -> String or Fixnum'
def the_answer(x)
  if x == 42
    return 'forty-two'
  else
    return 42
  end
end

the_answer(42)
the_answer(41)
