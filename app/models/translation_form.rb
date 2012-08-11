class TranslationForm
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion

  attr_accessor :name, :from, :to, :ctxt
  attr_accessor :translation, :ctx_translation

  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z\s]+\z/, message: 'is not a dictionary word' }, unless: ->(tf) { tf.name.blank? }
  validate  :from_to_langs_are_different, unless: ->(tf) { tf.name.blank? or (tf.from.blank? and tf.to.blank?) }
  
  before_validation do |tf|
    tf.name = tf.name.squish.downcase
    tf.ctxt = tf.ctxt.squish
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end

    # Devel purposes only
    self.translation     = "translated"
    self.ctx_translation = "context translation provided by translation service" unless ctxt.empty?
  end

  def persisted?
    false
  end

  def word_attributes
    {
      name: name,
      from_lang: from,
      to_lang: to,
      translation: translation,
      contexts_attributes: [{ sentence: ctxt, translation: ctx_translation }]
    }
  end

  def error_messages
    errors.full_messages.to_sentence.humanize
  end

private

  def from_to_langs_are_different
    errors[:base] << "Make sure that source and target languages are different" unless from != to
  end
end
