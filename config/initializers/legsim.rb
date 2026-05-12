LEGSIM_COPYRIGHT = '2001 - 2020'
LEGSIM_HOST = ENV.fetch("APP_HOST", "www.legsim.org").delete_prefix("http://").delete_prefix("https://").delete_suffix("/")
LEGSIM_PROTOCOL = ENV.fetch("APP_PROTOCOL", "https")
LEGSIM_URL = "#{LEGSIM_PROTOCOL}://#{LEGSIM_HOST}"
LEGACY_LEGSIM_INFO_URL = "http://info.legsim.org"
LEGSIM_INFO_ARCHIVE_URL = "https://web.archive.org/web/20200801000000/#{LEGACY_LEGSIM_INFO_URL}"
legsim_info_url = ENV["LEGSIM_INFO_URL"].to_s.strip
LEGSIM_INFO_URL = (legsim_info_url.empty? ? LEGSIM_INFO_ARCHIVE_URL : legsim_info_url).delete_suffix("/")
AUTO_CONFIRM_USERS = %w[1 true yes on].include?(ENV["AUTO_CONFIRM_USERS"].to_s.downcase)

Time::DATE_FORMATS[:long_with_time] = "%B %e, %Y %I:%M %p"
Time::DATE_FORMATS[:long] = "%B %e, %Y"
Time::DATE_FORMATS[:short_with_time] = "%b %e, %I:%M %p"
Time::DATE_FORMATS[:short] = "%b %e"
Time::DATE_FORMATS[:short_with_year] = "%b %e, %Y"

Time::DATE_FORMATS[:date_entry] = "%m/%d/%Y"
Time::DATE_FORMATS[:time_entry] = "%I:%M %p"

class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end

  def ceil_to(x)
    (self * 10**x).ceil.to_f / 10**x
  end

  def floor_to(x)
    (self * 10**x).floor.to_f / 10**x
  end
end
