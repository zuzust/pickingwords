class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  field :name
  field :picked, type: Integer, default: 0

  has_many :picks, class_name: "PickedWord", validate: false, dependent: :destroy do
    def search(name, from_lang, to_lang)
      criteria = named(name).localized_in(from_lang).translated_into(to_lang)

      if criteria.exists?
        picked = criteria.first
        picked.timeless.update_attribute(:searches, picked.searches + 1)
        return picked
      end

      return nil
    end
  end

  embeds_one :profile, class_name: "UserProfile"

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :confirmed_at

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  index :name, unique: true

  before_create  { |user| user.build_profile }

  delegate :trans_chars, :searches, :favs, :update_counter, to: :profile
end
