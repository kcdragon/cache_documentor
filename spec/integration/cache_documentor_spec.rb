require 'spec_helper'

describe CacheDocumentor do

  let(:controller) do
    file = File.open('spec/test_files/foo_controller.rb')
    contents = file.read
    file.close
    contents
  end

  let(:sexp) do
    parser = RubyParser.new
    parser.parse(controller)
  end

  describe '.document_path' do
    it 'process is called' do
      CacheSexpProcessor.any_instance.should_receive(:process).with(sexp)
      CacheDocumentor.document_path('spec/test_files/foo_controller.rb')
    end
  end

  describe '.document_application' do
    it 'process is called' do
      CacheSexpProcessor.any_instance.should_receive(:process).with(sexp)
      CacheDocumentor.document_application('spec/test_files')
    end
  end
end
