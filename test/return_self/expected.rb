require 'rdl'
require 'types/core'

class A
  extend RDL::Annotate
  type A, :id, '() -> self'
  def id
    self
  end
end

class B < A
end

A.new.id()
B.new.id()
