class CacheSexpProcessor < MethodBasedSexpProcessor

  attr_reader :cache_statements

  def initialize
    @cache_statements = []
    super
  end

  def process_call(exp)
    if is_cache_statement?(exp)
      @cache_statements << CacheStatement.new(class_name: @class_stack.first.to_s,
                                              method_name: @method_stack.first)
    end
    exp
  end

  def is_cache_statement?(exp)
    exp.rest.rest.first == :fetch &&
      exp.rest.first.rest.rest.first == :cache &&
      exp.rest.first.rest.first.rest.first == :Rails
  end
  private :is_cache_statement?
end
