class TrackedWord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :searches, type: Integer, default: 1
  field :picked,   type: Integer, default: 0
  field :favs,     type: Integer, default: 0

  embeds_one :word, inverse_of: :tracked, validate: false

  accepts_nested_attributes_for :word
  attr_protected :searches, :picked, :favs
  
  validates :word, presence: true

  index [[:searches, Mongo::DESCENDING]], background: true
  index [[:picked,   Mongo::DESCENDING]], background: true
  index [[:favs,     Mongo::DESCENDING]], background: true
  index "word.name.ca", sparse: true, background: true
  index "word.name.es", sparse: true, background: true
  index "word.name.en", sparse: true, background: true

  delegate :name, :localize, :translate, :translations, to: :word

  scope :by_asc_name,    ->(locale = I18n.default_locale) { asc("word.name.#{locale}") }
  scope :by_desc_name,   ->(locale = I18n.default_locale) { desc("word.name.#{locale}") }
  scope :named,          ->(name, locale = I18n.default_locale) { where("word.name.#{locale}" => name) }
  scope :beginning_with, ->(letter, locale = I18n.default_locale) { where("word.name.#{locale}" => /^#{letter}/i) }
  scope :top_searched,   ->(limit = nil) { desc(:searched).limit(limit) }
  scope :top_picked,     ->(limit = nil) { desc(:picked).limit(limit) }
  scope :top_faved,      ->(limit = nil) { desc(:favs).limit(limit) }
end
