class Hash
  def transform_hash(options = {}, &block)
    inject({}) do |result, (key, value)|
      value = if options[:deep] && Hash == value
                transform_hash(value, options, &block)
              else
                if Array == value
                  value.map { |v| transform_hash(v, options, &block) }
                else
                  value
                end
              end
      block.call(result, key, value)
      result
    end
  end

  def stringify_keys
    transform_hash do |hash, key, value|
      hash[key.to_s] = value
    end
  end

  def deep_stringify_keys
    transform_hash(deep: true) do |hash, key, value|
      hash[key.to_s] = value
    end
  end
end
