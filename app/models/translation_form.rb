class TranslationForm < BaseForm
  attr_accessor :name, :from, :to, :ctxt

  validates :name, presence: true
  validates :name, format: { with: /\A[-a-zA-Z\s]+\z/, message: 'is not a dictionary word' }, unless: ->(tf) { tf.name.blank? }
  validate  :from_to_langs_are_different, unless: ->(tf) { tf.name.blank? or (tf.from.blank? and tf.to.blank?) }
  
  before_validation do |tf|
    tf.name = tf.name.squish.downcase
    tf.ctxt = tf.ctxt.squish
  end

private

  def from_to_langs_are_different
    errors[:base] << "Make sure that source and target languages are different" unless from != to
  end
end
