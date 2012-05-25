class TrackedWord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String,  default: "unset", localize: true
  field :searches, type: Integer, default: 1
  field :picked,   type: Integer, default: 0
  field :favs,     type: Integer, default: 0

  has_many :picks, class_name: "PickedWord", inverse_of: :tracked, validate: false

  attr_accessible :name
  
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

  before_destroy :ensure_not_picked

  class << self

    def search(name, from_lang)
      criteria = named(name, from_lang)

      if criteria.exists?
        tracked = criteria.first
        tracked.inc(:searches, 1)
        return tracked
      end

      return nil
    end

    def update_or_create(from_lang, name, to_lang, translation)
      tracked = search(name, from_lang)

      if tracked
        tracked.localize(to_lang, translation) if tracked.translate(to_lang).blank?
      else
        tracked = TrackedWord.new
        tracked.localize(from_lang, name)
        tracked.localize(to_lang, translation)
      end

      tracked.save
      tracked
    end

  end

  def localize(locale, translation)
    previous_locale = I18n.locale

    I18n.locale = locale
    self.name = translation
    I18n.locale = previous_locale

    self
  end

  def translate(locale)
    name_translations[locale]
  end

  def translations
    name_translations
  end

  def update_counter(counter, value)
    inc(counter, value)
  end

  private

  def ensure_not_picked
    not_picked = picked == 0
    self.errors[:base] << 'Unable to destroy the requested word. Dependent picked words exist.' unless not_picked
    not_picked
  end
end
