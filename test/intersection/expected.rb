require 'rdl'
include RDL::Annotate

type '(TrueClass) -> String'
type '(FalseClass) -> Integer'
type '(NilClass) -> Integer'
type '(String) -> String'
type '(Integer) -> String'
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
