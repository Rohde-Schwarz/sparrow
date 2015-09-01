class Hash
  # Defines deep_transform_keys as available in ActiveSupport >= 4.0.2.
  # See {http://apidock.com/rails/v4.2.1/Hash/deep_transform_keys}
  def deep_transform_keys(&block)
    deep_transform_in_object(self, &block)
  end

  private 

  def deep_transform_in_object(obj, &block)
    case obj 
      when Hash
        obj.each_with_object({}) do |(key,value), result|
          result[yield(key)] = deep_transform_in_object(value, &block)
        end
      when Array
        obj.map { |el| deep_transform_in_object(el, &block) }
      else
        obj
    end
  end
end

