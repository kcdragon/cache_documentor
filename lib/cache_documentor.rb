require 'active_support/all'
require 'find'
require 'ruby_parser'
require 'ruby2ruby'
require 'sexp_processor'

require 'cache_documentor/cache_sexp_processor'
require 'cache_documentor/cache_statement'
require 'cache_documentor/directory_traverser'

module CacheDocumentor
  extend self

  def document_path(path)
    file = File.open('spec/test_files/foo_controller.rb')
    contents = file.read
    file.close

    parser = RubyParser.new
    sexp = parser.parse(contents)
    CacheSexpProcessor.new.process(sexp)
  end

  def document_application(path, options = {})
    processor = CacheSexpProcessor.new
    parser = RubyParser.new

    file_handler = lambda do |file_path|
      file = File.open(file_path)
      contents = file.read
      file.close

      sexp = parser.parse(contents)
      processor.process(sexp)
    end

    traverser = DirectoryTraverser.new(file_handler, options)
    traverser.process(path)

    processor
  end
end
