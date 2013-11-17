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

  it 'stores class name that cache statement is in' do
    subject.cache_statements.first.class_name.should == 'FooController'
  end

  it 'stores method name that cache statement is in' do
    subject.cache_statements.first.method_name.should == 'index'
  end

  it 'stores key passed to cache statement' do
    subject.cache_statements.first.key.should == 'key'
  end

  it 'stores options passed to cache statement' do
    subject.cache_statements.first.options.should == { expires_in: 5.minutes }
  end
end
