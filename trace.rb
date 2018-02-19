set_trace_func proc { |event, file, line, id, binding, classname|
  printf "%8s %s:%-2d %10s %8s\n", event, file, line, id, classname
  if classname == Fixnum and id == :add and event == 'call'
    # We can, of course, find the receiver of the current method
    me = binding.eval("self")

    # And the binding gives us access to all variables declared
    # in that method's scope. At call time only the method arguments will be
    # defined.
    args = binding.eval("local_variables").inject({}) do |vars, name|
      value = binding.eval name
      vars[name] = value unless value.nil?
      vars
    end

    #puts args

    # Pick some strings
    strings = locals.delete_if do |name, value|
      not value.kind_of? String
    end

    # We can also *change* those arguments.
    args.each do |name, value|
      if Numeric === value
        binding.eval "#{name} = #{value + 1}"
      end
    end
  end
}
