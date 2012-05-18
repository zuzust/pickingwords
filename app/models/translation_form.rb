class TranslationForm
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Conversion

  attr_accessor :from_lang, :name, :to_lang, :translation

  validates :from_lang, :name, :to_lang, presence: true
  validates :name, format: { with: /\A[a-zA-Z]+\z/, message: 'is not a dictionary word' }, unless: Proc.new { |tf| tf.name.blank? }
  
  before_validation { |tf| tf.name = tf.name.squish.downcase }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
