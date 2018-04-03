require 'rdl'
include RDL::Annotate

type '(Integer) -> String or Integer'
def the_answer(x)
  if x == 42
    return 'forty-two'
  else
    return 42
  end
end

the_answer(42)
the_answer(41)
