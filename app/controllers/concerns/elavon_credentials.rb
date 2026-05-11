module ElavonCredentials
  extend ActiveSupport::Concern

  private

  def elavon_credentials
    credentials_key = Rails.env.production? ? :production : :testing
    env_prefix = "ELAVON_#{credentials_key.to_s.upcase}"
    credentials = Rails.application.credentials.elavon || {}
    selected_credentials = credentials[credentials_key] || {}

    {
      login: ENV["#{env_prefix}_LOGIN"].presence || ENV["ELAVON_LOGIN"].presence || selected_credentials[:login],
      user: ENV["#{env_prefix}_USER"].presence || ENV["ELAVON_USER"].presence || selected_credentials[:user],
      password: ENV["#{env_prefix}_PASSWORD"].presence || ENV["ELAVON_PASSWORD"].presence || selected_credentials[:password]
    }
  end
end
