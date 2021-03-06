class PickedWordObserver < Mongoid::Observer

  def before_create(picked)
    if picked.fav
      picked.tracked.update_counter(:favs, 1)
      picked.user.update_counter(:favs, 1)
    end
  end

  def before_update(picked)
    if picked.searches_changed?
      picked.tracked.update_counter(:searches, 1)
      picked.user.update_counter(:searches, 1)
    end

    if picked.fav_changed?
      inc = picked.fav ? 1 : -1
      picked.tracked.update_counter(:favs, inc)
      picked.user.update_counter(:favs, inc)
    end
  end

  def before_destroy(picked)
    if picked.fav
      picked.tracked.update_counter(:favs, -1)
      picked.user.update_counter(:favs, -1)
    end
  end

  def after_create(picked)
    picked = picked.reload
    Rails.cache.write("picked_words/#{picked.id}", picked, expires_in: 1.hour)
  end

  def after_update(picked)
    Rails.cache.delete("picked_words/#{picked.id}")
  end

  def after_destroy(picked)
    Rails.cache.delete("picked_words/#{picked.id}")
  end

end
