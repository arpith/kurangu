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

def is_block(t)
  t.event == :b_return or t.event == :b_call
end

def tracepoint_line(t)
  if is_block(t)
    t.lineno
  else
    t.self.method(t.method_id).source_location[1]
  end
end

trace_return = TracePoint.new(:return, :b_return) do |t|
  if File.dirname(t.path) == File.dirname(INPUT_FILE)
    s = "#{t.path} #{tracepoint_line(t)}"
    args = stack[s].pop
    if args
      if !signatures.key?(s)
        parameters = t.self.method(t.method_id).parameters
        signatures[s] = MethodSignature.new(tracepoint_line(t), t.defined_class, t.method_id, is_block(t), parameters, signatures)
      end
      signatures[s].add(args, t.return_value, t.self)
      path = "#{t.path}.annotations"
      dir = File.dirname(t.path)
      write_annotations_paths(dir, paths.add(path))
      write_annotations(path, signatures)
    end
  end
end

trace_call = TracePoint.new(:call, :b_call) do |t|
  if File.dirname(t.path) == File.dirname(INPUT_FILE)
    s = "#{t.path} #{tracepoint_line(t)}"
    args = t.binding.eval("local_variables").inject({}) do |vars, name|
      value = t.binding.eval name.to_s
      vars[name] = value
      vars
    end
    stack[s] << args
  end
end

trace_return.enable
trace_call.enable
