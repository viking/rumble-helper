# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rumble-tracker_session',
  :secret      => '74c3f44e4c5865b6ad761540783b26568ca01cf89d437e674c463341a599a2ef72ff7cffa691066bfb1a0a536c1cd9f0116b01036bab1ef4c78949571cb61c99'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
