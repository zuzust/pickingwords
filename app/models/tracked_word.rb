class TrackedWord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :searches, type: Integer, default: 1
  field :picks, type: Integer, default: 0
  field :favs, type: Integer, default: 0

  has_one :word, as: :wordable, autosave: true, dependent: :destroy

  accepts_nested_attributes_for :word

  attr_protected :searches, :picks, :favs, :word
  
  # default_scope desc(:updated_at)

  def name
    word.name
  end

  def localize(locale, translation)
    word.localize(locale, translation)
  end

  def translate(locale)
    word.translate(locale)
  end

  def translations
    word.translations
  end
end
