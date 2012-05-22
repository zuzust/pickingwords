class TranslationForm
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion

  attr_accessor :from_lang, :name, :ctx_sentence, :to_lang, :translation, :ctx_translation

  validates :from_lang, :name, :to_lang, presence: true
  validates :name, format: { with: /\A[a-zA-Z]+\z/, message: 'is not a dictionary word' }, unless: ->(tf) { tf.name.blank? }
  
  before_validation do |tf|
    tf.name = tf.name.squish.downcase
    tf.ctx_sentence = tf.ctx_sentence.squish
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def word_attributes
    {
      from_lang: from_lang,
      name: name,
      to_lang: to_lang,
      translation: translation,
      contexts_attributes: [{ sentence: ctx_sentence, translation: ctx_translation }]
    }
  end
end
