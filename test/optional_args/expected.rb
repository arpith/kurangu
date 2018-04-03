require 'rdl'
include RDL::Annotate

type '(?Fixnum v) -> String'
type '(?NilClass v) -> String'
def the_answer(v = nil)
  return 'forty-two'
end

the_answer(42)
the_answer()
