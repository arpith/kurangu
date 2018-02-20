require 'set'

stack = Hash.new Array.new
parameter_types = Hash.new Hash.new Set.new
return_types = Hash.new Array.new
parameter_list = Hash.new Array.new

trace_return = TracePoint.new(:return) do |t|
  s = "#{t.defined_class}.#{t.method_id}"
  args = stack[s].pop
  if args
    args.each do |arg, type|
      parameter_types[s][arg].add(type)
    end
    return_types[s] << t.return_value.class
    parameter_list[s] = t.self.method(t.method_id).parameters.map { |a | a[1] }
    joined_parameters = parameter_list[s].map { |arg| parameter_types[s][arg].to_a.join(" or ") }
    puts "(#{joined_parameters.join(", ")}) -> #{return_types[s].join(" or ")}"
  end
end

trace_call = TracePoint.new(:call) do |t|
  args = t.binding.eval("local_variables").inject({}) do |vars, name|
    value = t.binding.eval name.to_s
    vars[name] = value.class
    vars
  end
  stack["#{t.defined_class}.#{t.method_id}"] << args
end

trace_return.enable
trace_call.enable
