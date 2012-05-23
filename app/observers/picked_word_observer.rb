class PickedWordObserver < Mongoid::Observer

  def before_save(picked)
    if picked.fav_changed?
      if picked.fav
        picked.tracked.inc(:favs, 1)
      else
        picked.tracked.inc(:favs, -1) unless picked.tracked.favs == 0
      end
    end
  end

  def before_update(picked)
    if picked.searches_changed?
      picked.tracked.inc(:searches, 1)
    end
  end

  def after_destroy(picked)
    if picked.fav
      picked.tracked.inc(:favs, -1)
    end
  end

end
