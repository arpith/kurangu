require 'rdl'
require 'types/core'

extend RDL::Annotate
type Object, :the_answer, '(?Fixnum v) -> String'
type Object, :the_answer, '(?NilClass v) -> String'
def the_answer(v = nil)
  return 'forty-two'
end

the_answer(42)
the_answer()
