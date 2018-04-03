require 'rdl'
include RDL::Annotate

type '(?Fixnum) -> String'
type '(?NilClass) -> String'
def the_answer(v = nil)
  return 'forty-two'
end

the_answer(42)
the_answer()
