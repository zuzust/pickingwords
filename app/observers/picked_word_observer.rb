class PickedWordObserver < Mongoid::Observer

  def before_save(picked)
    if picked.fav_changed?
      if picked.fav
        picked.tracked.update_counter(:favs, 1)
        picked.user.update_counter(:favs, 1)
      else
        picked.tracked.update_counter(:favs, -1) unless picked.tracked.favs == 0
        picked.user.update_counter(:favs, -1) unless picked.user.favs == 0
      end
    end
  end

  def before_update(picked)
    if picked.searches_changed?
      picked.tracked.update_counter(:searches, 1)
    end
  end

  def before_destroy(picked)
    if picked.fav
      picked.tracked.update_counter(:favs, -1)
      picked.user.update_counter(:favs, -1)
    end
  end

end
