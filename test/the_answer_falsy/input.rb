require 'rdl'
require 'types/core'

extend RDL::Annotate
type '(TrueClass or FalseClass or NilClass or String or Fixnum) -> String or Fixnum'
def the_answer(x)
  if x
    return 'forty-two'
  else
    return 42
  end
end

the_answer(true)
the_answer(false)
the_answer(nil)
the_answer("string")
the_answer(42)
