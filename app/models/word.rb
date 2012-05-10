class Word
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  field :name, default: "unknown", localize: true

  embedded_in :tracked, class_name: "TrackedWord"

  validates :name, presence: true

  def localize(locale, translation)
    self.name_translations[locale] = translation
    self
  end

  def translate(locale)
    name_translations[locale]
  end

  def translations
    name_translations
  end
end
