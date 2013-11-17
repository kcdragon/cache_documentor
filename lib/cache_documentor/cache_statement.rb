class CacheStatement

  attr_accessor :class_name, :method_name, :key, :options

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end

    @options ||= {}
  end

  def as_prose
    <<-EOS
    #{details} #{subject}. #{expires_in}.
    EOS
  end

  def to_s
    "Class: #{@class_name}, Method: #{@method_name}"
  end

private

  def subject
    name = if controller?
             class_name.gsub(/Controller/, '')
           else
             class_name
           end

    name.titleize
  end

  def details
    if controller? && action?
      action_to_prose
    else
      method_name
    end
  end

  def expires_in
    return 'Cache does not expire' unless options[:expires_in]

    seconds = options[:expires_in]
    if seconds / 60.0 > 1
      minutes = seconds / 60.0
      if minutes / 60.0 > 1
        # TODO
      else
        "Cache expires in #{minutes.ceil} minutes"
      end
    else
      "Cache expires in #{seconds.ceil} seconds"
    end
  end

  def controller?
    class_name =~ /Controller/
  end

  def action?
    ['index', 'show', 'create', 'new', 'update', 'edit', 'destroy'].include?(method_name)
  end

  def action_to_prose
    @@action_to_prose[method_name]
  end

  @@action_to_prose = Hash.new { |hash, key| hash[key] = key }
  @@action_to_prose['index'] = 'displaying all'
end
