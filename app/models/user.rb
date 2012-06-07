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

  field :name,   type: String
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

  validates :name, presence: true
  validates_uniqueness_of :name, :email, :case_sensitive => false

  index :name, unique: true, background: true
  index [["profile.searches", Mongo::DESCENDING]], background: true
  index [[:picked,   Mongo::DESCENDING]], background: true

  default_scope asc(:name)
  scope :top_searchers, ->(limit = nil) { desc("profile.searches").limit(limit) }
  scope :top_pickers,   ->(limit = nil) { desc(:picked).limit(limit) }

  before_create  { |user| user.build_profile }

  class << self
    # See:
    # http://kylebanker.com/blog/2009/12/mongodb-map-reduce-basics/
    # https://github.com/mongoid/echo/blob/master/app/models/following.rb
    # http://www.mongodb.org/display/DOCS/MapReduce#MapReduce-Examples
    # http://api.mongodb.org/ruby/current/Mongo/Collection.html#map_reduce-instance_method
    # http://api.mongodb.org/ruby/current/Mongo/Collection.html#find-instance_method
    def top_active(limit = nil)
      m = %Q{
        function() {
          emit(this._id, {name: this.name, activity: (this.picked + this.profile.searches)});
        }
      }

      r = %Q{
        function(key, values) {
          var result = {name: '', activity: 0};
          values.forEach(function(value) {
            result.name     = value.name;
            result.activity = value.activity;
          });
          return result;
        }
      }

      collection.map_reduce(m, r, out: "active_users")
                .find({}, {limit: limit, sort: [["value.activity", :desc]]})
                .map { |u| [u["_id"], u["value"]["name"], u["value"]["activity"]] }
    end
  end

  delegate :trans_chars, :searches, :favs, :update_counter, to: :profile
end
