require 'set'
require 'signature'

INPUT_FILE = $stdin.readline.chomp

stack = Hash.new { |h, k| h[k] = [] }
signatures = Hash.new
paths = Set.new

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
      parameter_list = t.self.method(t.method_id).parameters.map { |a | a[1] }
      line = t.self.method(t.method_id).source_location[1]
      if !signatures.key?(s)
        signatures[s] = MethodSignature.new(line, parameter_list)
      end
      signatures[s].add(args, t.return_value.class)
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
