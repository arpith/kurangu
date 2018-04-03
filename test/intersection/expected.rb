require 'rdl'
include RDL::Annotate

type '(TrueClass x) -> String'
type '(FalseClass x) -> Fixnum'
type '(NilClass x) -> Fixnum'
type '(String x) -> String'
type '(Fixnum x) -> String'
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