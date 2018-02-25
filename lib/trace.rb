require 'set'

INPUT_FILE = $stdin.readline.chomp

stack = Hash.new Array.new
parameter_types = Hash.new Hash.new Set.new
return_types = Hash.new Set.new
parameter_list = Hash.new Array.new
signatures = Hash.new
paths = Set.new

def generate_signature(line, parameters, parameter_types, return_types)
  joined_parameters = parameters.map { |arg| parameter_types[arg].to_a.join(" or ") }
  "#{line} type '(#{joined_parameters.join(", ")}) -> #{return_types.to_a.join(" or ")}'"
end

def write_annotations_paths(dir, paths)
  paths_file = "#{dir}/annotations_paths.txt"
  IO.write(paths_file, paths.to_a.join("\n"))
end

def write_annotations(path, signatures)
  IO.write(path, signatures.values.join("\n"))
end

trace_return = TracePoint.new(:return) do |t|
  if File.dirname(t.path) == File.dirname(INPUT_FILE)
    s = "#{t.defined_class}, :#{t.method_id}"
    args = stack[s].pop
    if args
      args.each do |arg, type|
        parameter_types[s][arg].add(type)
      end
      return_types[s].add(t.return_value.class)
      parameter_list[s] = t.self.method(t.method_id).parameters.map { |a | a[1] }
      line = t.self.method(t.method_id).source_location[1]
      signatures[s] = generate_signature(line, parameter_list[s], parameter_types[s], return_types[s])
      path = "#{t.path}.annotations"
      dir = File.dirname(t.path)
      write_annotations_paths(dir, paths.add(path))
      write_annotations(path, signatures)
    end
  end
end

trace_call = TracePoint.new(:call) do |t|
  if File.dirname(t.path) == File.dirname(INPUT_FILE)
    s = "#{t.defined_class}, :#{t.method_id}"
    args = t.binding.eval("local_variables").inject({}) do |vars, name|
      value = t.binding.eval name.to_s
      vars[name] = value.class
      vars
    end
    stack[s] << args
  end
end

trace_return.enable
trace_call.enable
