def return_value(x)
  return Proc.new { |y| 42 }
end

def argument(x, y)
  return 42
end

def method_block(x, &blk)
  return 42
end

the_answer = return_value(1)
argument(1, the_answer)
method_block(1, &the_answer)
the_answer.call(1)
