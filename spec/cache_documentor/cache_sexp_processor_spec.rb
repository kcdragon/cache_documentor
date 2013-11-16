require 'spec_helper'

describe CacheSexpProcessor do

  let(:controller) do
    file = File.open('spec/test_files/foo_controller.rb')
    contents = file.read
    file.close
    contents
  end

  before(:each) do
    parser = RubyParser.new
    sexp = parser.parse(controller)
    subject.process(sexp)
  end

  it 'returns class name that cache statement is in' do
    subject.cache_statements.first.class_name.should == 'FooController'
  end

  it 'returns method name that cache statement is in' do
    subject.cache_statements.first.method_name.should == 'index'
  end
end
