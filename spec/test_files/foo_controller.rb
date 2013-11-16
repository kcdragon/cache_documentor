class FooController < ApplicationController
  def index
    Rails.cache.fetch('key') do
      Bar.all
    end
  end
end
