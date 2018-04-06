require 'rdl'
require 'types/core'
extend RDL::Annotate

type Object, :return_value, '(Fixnum) -> { (Fixnum) -> Fixnum }'
def return_value(x)
  return Proc.new { |y| 42 }
end

type Object, :argument, '(Fixnum, { (Fixnum) -> Fixnum }) -> Fixnum'
def argument(x, y)
  return 42
end

type Object, :method_block, '(Fixnum) { (Fixnum) -> Fixnum } -> Fixnum'
def method_block(x, &blk)
  return 42
end

the_answer = return_value(1)
argument(1, the_answer)
method_block(1, &the_answer)
the_answer.call(1)
#the_answer.call("foo")
