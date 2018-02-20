require 'set'

stack = Hash.new Array.new
parameter_types = Hash.new Hash.new Set.new
return_types = Hash.new Array.new
parameter_list = Hash.new Array.new
signatures = Hash.new

def generate_signature(parameters, parameter_types, return_types)
  joined_parameters = parameters.map { |arg| parameter_types[arg].to_a.join(" or ") }
  "(#{joined_parameters.join(", ")}) -> #{return_types.join(" or ")}"
end

def write_annotations(signatures)
  lines = signatures.to_a.map{ | name, signature | "#{name} #{signature}" }
  IO.write('annotations.rb', lines.join("\n"))
end

trace_return = TracePoint.new(:return) do |t|
  s = "type #{t.defined_class}, :#{t.method_id}"
  args = stack[s].pop
  if args
    args.each do |arg, type|
      parameter_types[s][arg].add(type)
    end
    return_types[s] << t.return_value.class
    parameter_list[s] = t.self.method(t.method_id).parameters.map { |a | a[1] }
    signatures[s] = generate_signature(parameter_list[s], parameter_types[s], return_types[s])
    write_annotations(signatures)
  end
end

trace_call = TracePoint.new(:call) do |t|
  s = "type #{t.defined_class}, :#{t.method_id}"
  args = t.binding.eval("local_variables").inject({}) do |vars, name|
    value = t.binding.eval name.to_s
    vars[name] = value.class
    vars
  end
  stack[s] << args
end

trace_return.enable
trace_call.enable
