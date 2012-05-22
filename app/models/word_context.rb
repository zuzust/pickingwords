class WordContext
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :sentence,    type: String
  field :translation, type: String

  embedded_in :pick, class_name: "PickedWord", inverse_of: :contexts

  attr_accessible :sentence, :translation
  
  validates :sentence, :translation, presence: true
end
