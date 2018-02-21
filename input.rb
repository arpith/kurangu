class Test
  def plus(a, b)
    return a + b
  end

  def first(a, b)
    return a
  end
end

t = Test.new
t.plus(1, 2)
t.plus('1', '3')
t.first(1, 3)
t.first('a', 'b')
