require 'rdl'
include RDL::Annotate

class A
  type A, :initialize, '(Fixnum) -> self'
  def initialize(a)
    @a = a
  end
end

A.new(2)
