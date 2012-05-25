class UserProfile
  include Mongoid::Document

  field :trans_chars, type: Integer, default: 0
  field :searches,    type: Integer, default: 0
  field :favs,        type: Integer, default: 0

  embedded_in :user, inverse_of: :profile

  def update_counter(counter, value)
    inc(counter, value)
  end
end
