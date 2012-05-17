class PickedWord
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache

  field :from_lang,   type: String
  field :name,        type: String
  field :to_lang,     type: String
  field :translation, type: String
  field :fav,         type: Boolean, default: false
  field :searches,    type: Integer, default: 1

  belongs_to :tracked, class_name: "TrackedWord", inverse_of: :picks, index: true
  counter_cache :tracked, field: "picked"

  attr_accessible :from_lang, :name, :to_lang, :translation, :fav

  validates :from_lang, :name, :to_lang, :translation, :tracked, presence: true

  index [[:name, Mongo::ASCENDING], [:from_lang, Mongo::ASCENDING], [:to_lang, Mongo::ASCENDING]], background: true
  index [[:searches, Mongo::DESCENDING]], background: true
  index :fav, background: true
  
  default_scope asc(:name)
  scope :named,           ->(name) { where(name: name) }
  scope :beginning_with,  ->(letter) { where(:name => /^#{letter}/i) }
  scope :localized_in,    ->(locale) { where(from_lang: locale) }
  scope :translated_into, ->(locale) { where(to_lang: locale) }
  scope :top_searched,    ->(limit = nil) { desc(:searches).limit(limit) }
  scope :faved,           where(fav: true)

  class << self
    
    def search(name, from_lang, to_lang)
      criteria = named(name).localized_in(from_lang).translated_into(to_lang)

      if criteria.exists?
        picked = criteria.first
        picked.inc(:searches, 1)
        return picked
      end

      return nil
    end

  end

  def base_translation
    tracked.translate(to_lang)
  end
end
