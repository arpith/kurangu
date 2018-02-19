trace_return = TracePoint.new(:return) do |t| # event type specification is optional
  puts "returning #{t.return_value.class} from #{t.defined_class}.#{t.method_id}"
end

trace_call = TracePoint.new(:call) do |t| # event type specification is optional
  args = t.binding.eval("local_variables").inject({}) do |vars, name|
    value = t.binding.eval name.to_s
    vars[name] = value.class
    vars
  end
  puts "calling #{t.defined_class}.#{t.method_id} with #{args}"
end

trace_return.enable
trace_call.enable
