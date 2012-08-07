class TranslationForm
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion

  attr_accessor :from_lang, :name, :ctx_sentence, :to_lang, :translation, :ctx_translation

  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z\s]+\z/, message: 'is not a dictionary word' }, unless: ->(tf) { tf.name.blank? }
  
  before_validation do |tf|
    tf.name = tf.name.squish.downcase
    tf.ctx_sentence = tf.ctx_sentence.squish
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end

    # Devel purposes only
    self.translation     = "translated"
    self.ctx_translation = "context translation provided by translation service" unless ctx_sentence.empty?
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

  def error_messages
    errors.full_messages.to_sentence
  end
end
