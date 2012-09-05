class SearchForm < BaseForm
  attr_accessor :name, :from, :to, :ctxt

  validates :name, presence: true
  validates :name, format: { with: /\A[-a-zA-Z\s]+\z/, message: 'is not a dictionary word' }, unless: ->(sf) { sf.name.blank? }
  validate  :from_to_langs_are_different, unless: ->(sf) { sf.name.blank? or (sf.from.blank? and sf.to.blank?) }
  
  before_validation { |sf| sf.name = sf.name.squish.downcase }

  def to_params
    { name: name, from: from, to: to, ctxt: ctxt }
  end

private

  def from_to_langs_are_different
    errors[:base] << "Make sure that source and target languages are different" unless from != to
  end
end

