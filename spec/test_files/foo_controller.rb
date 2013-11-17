class FooController < ApplicationController
  def index
    Rails.cache.fetch('key', expires_in: 5.minutes) do
      Bar.all
    end
  end
end
