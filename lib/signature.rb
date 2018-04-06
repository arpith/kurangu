class MethodSignature
  def initialize(line, class_name, method_id, is_block, parameters, other_signatures)
    @line = line
    @class_name = class_name
    @method_id = method_id
    @is_block = is_block
    @parameters = parameters
    # For each parameter signature (key), store a set of return types (value)
    @return_values = Hash.new { | h, k | h[k] = Set.new }
    @parameter_values = Hash.new
    @other_signatures = other_signatures
  end

  def signature_prefix
    if !@is_block
      "#{@class_name}, :#{@method_id}, "
    else
      ""
    end
  end

  def expand_block(block)
    if block.class.to_s != "Proc"
      return
    end
    block_params = block.parameters
    block_id = "#{block.source_location[0]} #{block.source_location[1]}"
    if @other_signatures.key?(block_id)
      @other_signatures[block_id].update_parameters(block_params)
      block_signatures = @other_signatures[block_id].get_signatures
      if block_signatures.size == 1
        "{#{block_signatures[0]}}"
      elsif block_signatures.size > 1
        "{\n#{@other_signatures[block_id].get_signatures.join("\n")}\n}"
      end
    end
  end

  def generate_parameter_signature(parameter_values)
    signatures = @parameters.map do |parameter|
      prefix = ""
      if parameter[0] == :opt
        prefix = "?"
      end
      name = parameter[1]
      value = parameter_values[name]
      type = value.class
      if type.to_s == "Proc"
        expanded = expand_block(value)
        if expanded
          type = expanded
        end
      end
      "#{prefix}#{type} #{name}"
    end
    method_block_signature = ""
    if @parameters.size > 0 and @parameters[-1][0] == :block
      expanded = expand_block(parameter_values[@parameters[-1][1]])
      if expanded
        signatures.pop
        method_block_signature = " #{expanded}"
      end
    end
    "(#{signatures.join(", ")})#{method_block_signature}"
  end

  def generate_return_signature(return_values)
    types = return_values.to_a.map do |return_value|
      if return_value == "self"
        return_value
      else
        expanded = expand_block(return_value)
        if !expanded
          return_value.class
        else
          expanded
        end
      end
    end
    types.join(" or ")
  end

  def update_parameters(parameters)
    @parameters = parameters
  end

  def get_signatures
    @return_values.to_a.map do |a|
      parameter_values = @parameter_values[a[0]]
      parameter_signature = generate_parameter_signature(parameter_values)
      return_signature = generate_return_signature(a[1])
      "#{parameter_signature} -> #{return_signature}"
    end
  end

  def to_s
    signatures = get_signatures.map do |signature|
      "#{@line} type #{signature_prefix}'#{signature}'"
    end
    signatures.join("\n")
  end

  def add(parameter_values, return_value, owner)
    if return_value.class.to_s == owner.class.name or @method_id == :initialize
      return_value = "self"
    end
    parameter_sig = generate_parameter_signature(parameter_values)
    @return_values[parameter_sig].add(return_value)
    @parameter_values[parameter_sig] = parameter_values
  end

end
