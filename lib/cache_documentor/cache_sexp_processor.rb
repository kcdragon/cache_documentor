class CacheSexpProcessor < MethodBasedSexpProcessor

  attr_reader :cache_statements

  def initialize
    @cache_statements = []
    super
  end

  def process_call(exp)
    if is_cache_statement?(exp)
      args_exp = exp.rest.rest.rest

      key = extract_key(args_exp)
      options = extract_options(args_exp)

      @cache_statements << CacheStatement.new(class_name: @class_stack.first.to_s,
                                              method_name: @method_stack.first,
                                              key: key,
                                              options: options)
    end
    exp
  end

private

  def is_cache_statement?(exp)
    exp.rest.rest.first == :fetch &&
      exp.rest.first.rest.rest.first == :cache &&
      exp.rest.first.rest.first.rest.first == :Rails
  end

  def extract_key(args_exp)
    args_exp.first.rest.first
  end

  def extract_options(args_exp)
    ruby2ruby = Ruby2Ruby.new
    options_exp = args_exp.rest.first
    eval(ruby2ruby.process(options_exp))
  end
end
