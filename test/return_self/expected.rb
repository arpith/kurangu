require 'rdl'
include RDL::Annotate

class A
  type '() -> self'
  def id
    self
  end
end

class B < A
end

A.new.id()
B.new.id()
