class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @tracked_words = TrackedWord.by_asc_name
  end
end
