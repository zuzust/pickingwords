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

  belongs_to :user, class_name: "UserProfile", inverse_of: :picks, index: true
  belongs_to :tracked, class_name: "TrackedWord", inverse_of: :picks, index: true
  counter_cache :user, field: "picked"
  counter_cache :tracked, field: "picked"

  embeds_many :contexts, class_name: "WordContext", inverse_of: :pick
  accepts_nested_attributes_for :contexts, reject_if: :all_blank

  attr_accessible :from_lang, :name, :to_lang, :translation, :fav, :contexts_attributes

  validates :from_lang, :name, :to_lang, :translation, :user, :tracked, presence: true

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

  def base_translation
    tracked.translate(to_lang)
  end
end
