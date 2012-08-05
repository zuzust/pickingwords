# Be sure to restart your server when you modify this file.

Pickingwords::Application.config.session_store :cookie_store, key: '_pickingwords_session'

# To use Dalli for Rails session storage that times out after 20 minutes
# See https://github.com/mperham/dalli#usage-with-rails-3x
# Pickingwords::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 20.minutes

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Pickingwords::Application.config.session_store :active_record_store
