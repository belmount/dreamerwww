class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_recent_published

  def get_recent_published
    @news = Law.news.desc(:publish_at).limit(3)
  end
end
