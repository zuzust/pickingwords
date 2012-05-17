class PickedWordObserver < Mongoid::Observer
  
  def before_save(picked)
    if picked.fav_changed?
      picked.fav ? picked.tracked.inc(:favs, 1) : picked.tracked.inc(:favs, -1)
    end
  end

  def after_destroy(picked)
    picked.tracked.inc(:favs, -1) if picked.fav
  end

end
