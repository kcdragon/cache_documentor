require 'spec_helper'

describe CacheStatement do

  subject do
    CacheStatement.new(class_name: 'FooBar',
                       options: { expires_in: 5.minutes })
  end

  describe '#as_prose' do
    it 'multi word class is separated by spaces' do
      subject.as_prose.should =~ /Foo Bar/
    end

    it 'displays expires at info when expires at is set' do
      subject.as_prose.should =~ /5 minutes/
    end

    it 'displays default expires at info when expires at is not explicitly set' do
      subject.options = {}
      subject.as_prose.should =~ /does not expire/
    end

    it 'options defaults to empty hash' do
      CacheStatement.new.options.should == {}
    end

    context 'when statement is in a controller' do
      subject { CacheStatement.new(class_name: 'FooBarController', method_name: 'index') }

      it "removes 'Controller' keyword from class" do
        subject.as_prose.should_not =~ /Controller/
      end

      it 'replaces action method with a more descriptive name' do
        subject.as_prose.should_not =~ /index/
      end
    end
  end
end
