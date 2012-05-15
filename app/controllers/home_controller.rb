class HomeController < ApplicationController
  def index
    @tracked_words = TrackedWord.by_asc_name
  end
end
