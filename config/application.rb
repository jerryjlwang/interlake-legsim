require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Legsim
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    # we don't go in for any of that fancy cloud storage here, no thank you
    config.active_storage.service = :local
    config.hosts << "ihs.legsim.westus2.cloudapp.azure.com"
    config.hosts << ENV["APP_HOST"] if ENV["APP_HOST"].present?
    if ENV["RAILWAY_ENVIRONMENT"].present?
      config.hosts << "healthcheck.railway.app"
      config.hosts << /.*\.up\.railway\.app\z/
    end

    config.active_record.legacy_connection_handling = false

    gmail_credentials = Rails.application.credentials.gmail || {}
    gmail_user_name = ENV["GMAIL_USER_NAME"].presence || gmail_credentials[:user_name]
    gmail_password = ENV["GMAIL_PASSWORD"].presence || gmail_credentials[:password]

    if gmail_user_name.present? && gmail_password.present?
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        address:              'smtp.gmail.com',
        port:                 587,
        domain:               ENV.fetch("MAILER_DOMAIN", "legsim.org"),
        user_name:            gmail_user_name,
        password:             gmail_password,
        authentication:       'plain',
        enable_starttls_auto: true
      }
    end
  end
end
