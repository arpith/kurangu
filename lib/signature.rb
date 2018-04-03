class MethodSignature
  def initialize(line, parameters)
    @line = line
    @parameters = parameters
    # For each parameter signature (key), store a set of return types (value)
    @signatures = Hash.new { | h, k | h[k] = Set.new }
  end
 
  def generate_parameter_signature(parameter_types)
    joined_parameters = @parameters.map { |arg| parameter_types[arg] }
    joined_parameters.join(", ")
  end

  def to_s
    signatures = @signatures.to_a.map { |a| 
      "#{@line} type '(#{a[0]}) -> #{a[1].to_a.join(" or ")}'" 
    }
    signatures.join("\n")
  end

  def add(parameter_types, return_type)
    parameter_signature = generate_parameter_signature(parameter_types)
    @signatures[parameter_signature].add(return_type)
  end

end
