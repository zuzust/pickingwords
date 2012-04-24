class UserProfile
  include Mongoid::Document

  field :trans_chars, type: Integer, default: 0

  embedded_in :user, inverse_of: :profile
end
