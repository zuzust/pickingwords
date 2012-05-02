class HomeController < ApplicationController
  def index
    @tracked_words = TrackedWord.all
  end
end
