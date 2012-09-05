class ContactForm < BaseForm
  attr_accessor :name, :email, :subject, :body

  validates :name, :email, :body, presence: true
  validates :email, format: { with: /\A([\w\.\+\-]+)@([-\w]+\.)([\w]{2,})\z/i, message: 'is not well formed' }, unless: ->(cf) { cf.email.blank? }

  before_validation do |cf|
    cf.name    = cf.name.squish
    cf.email   = cf.email.squish
    cf.subject = cf.subject.squish
    cf.body    = cf.body.squish
  end
end
