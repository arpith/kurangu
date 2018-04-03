class MethodSignature
  def initialize(line, parameters)
    @line = line
    @parameters = parameters
    # For each parameter signature (key), store a set of return types (value)
    @signatures = Hash.new { | h, k | h[k] = Set.new }
  end
 
  def generate_parameter_signature(parameter_types)
    signatures = @parameters.map do |parameter|
      prefix = ""
      if parameter[0] == :opt
        prefix = "?"
      end
      "#{prefix}#{parameter_types[parameter[1]]} #{parameter[1]}"
    end
    signatures.join(", ")
  end

  def to_s
    signatures = @signatures.to_a.map { |a|
      "#{@line} type '(#{a[0]}) -> #{a[1].to_a.join(" or ")}'"
    }
    signatures.join("\n")
  end

  def add(parameter_types, return_type, owner)
    parameter_signature = generate_parameter_signature(parameter_types)
    if return_type.to_s == owner.class.name
      return_type = "self"
    end
    @signatures[parameter_signature].add(return_type)
  end

end
