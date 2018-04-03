class A
  def id
    self
  end
end

class B < A
end

A.new.id()
B.new.id()
