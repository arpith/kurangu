require 'rdl'
require 'types/core'

extend RDL::Annotate
type Object, :the_answer, '(TrueClass x) -> String'
type Object, :the_answer, '(FalseClass x) -> Fixnum'
type Object, :the_answer, '(NilClass x) -> Fixnum'
type Object, :the_answer, '(String x) -> String'
type Object, :the_answer, '(Fixnum x) -> String'
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
