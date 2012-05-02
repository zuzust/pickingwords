class Word
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, localize: true

  belongs_to :wordable, polymorphic: true, index:true

  index "name.ca"
  index "name.es"
  index "name.en"

  validates :name, presence: true

  def localize(locale, translation)
    self.name_translations[locale] = translation
  end

  def translate(locale)
    name_translations[locale]
  end

  def translations
    name_translations
  end
end
