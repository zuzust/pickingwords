class TrackedWord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String,  default: "unset", localize: true
  field :searches, type: Integer, default: 1
  field :picked,   type: Integer, default: 0
  field :favs,     type: Integer, default: 0

  attr_protected :searches, :picked, :favs
  
  validates :name, presence: true

  index [[:searches, Mongo::DESCENDING]], background: true
  index [[:picked,   Mongo::DESCENDING]], background: true
  index [[:favs,     Mongo::DESCENDING]], background: true
  index "name.en", sparse: true, background: true
  index "name.ca", sparse: true, background: true
  index "name.es", sparse: true, background: true

  scope :by_asc_name,    ->(locale = I18n.default_locale) { asc("name.#{locale}") }
  scope :by_desc_name,   ->(locale = I18n.default_locale) { desc("name.#{locale}") }
  scope :named,          ->(name, locale = I18n.default_locale) { where("name.#{locale}" => name) }
  scope :beginning_with, ->(letter, locale = I18n.default_locale) { where("name.#{locale}" => /^#{letter}/i) }
  scope :top_searched,   ->(limit = nil) { desc(:searched).limit(limit) }
  scope :top_picked,     ->(limit = nil) { desc(:picked).limit(limit) }
  scope :top_faved,      ->(limit = nil) { desc(:favs).limit(limit) }

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

  class << self

    def search(from_lang, name, to_lang, translation)
      tracked = named(name, from_lang).first

      if tracked
        tracked.localize(to_lang, translation) if tracked.translate(to_lang).blank?
      else
        tracked = TrackedWord.new
        tracked.localize(from_lang, name)
        tracked.localize(to_lang, translation)
      end

      tracked
    end

  end
end
