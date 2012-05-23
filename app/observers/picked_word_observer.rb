class PickedWordObserver < Mongoid::Observer

  def around_save(picked)
    saving_new = picked.new_record?
    changes    = picked.changed

    yield

    if changes.include?("searches")
      picked.tracked.inc(:searches, 1) unless saving_new
    end

    if changes.include?("fav")
      if picked.fav
        picked.tracked.inc(:favs, 1)
      else
        picked.tracked.inc(:favs, -1) unless picked.tracked.favs == 0
      end
    end
  end

  def after_destroy(picked)
    if picked.fav
      picked.tracked.inc(:favs, -1)
    end
  end

end
