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

  def after_destroy(picked)
    picked.tracked.inc(:favs, -1) if picked.fav
  end

end
