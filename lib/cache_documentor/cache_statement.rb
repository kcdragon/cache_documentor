class CacheStatement

  attr_accessor :class_name, :method_name

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def to_s
    "Class: #{@class_name}, Method: #{@method_name}"
  end
end
