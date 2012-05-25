class UserProfile
  include Mongoid::Document

  field :trans_chars, type: Integer, default: 0
  field :searches,    type: Integer, default: 0
  field :picked,      type: Integer, default: 0
  field :favs,        type: Integer, default: 0

  has_many :picks, class_name: "PickedWord", inverse_of: :user, validate: false, dependent: :destroy do
    def search(name, from_lang, to_lang)
      criteria = named(name).localized_in(from_lang).translated_into(to_lang)

      if criteria.exists?
        picked = criteria.first
        picked.timeless.update_attribute(:searches, picked.searches + 1)
        return picked
      end

      return nil
    end
  end

  embedded_in :user, inverse_of: :profile

  before_destroy { |profile| profile.picks.destroy_all }

  def update_counter(counter, value)
    inc(counter, value)
  end
end
