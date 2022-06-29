class WeatherCover
  API_KEY = 'dmG0mtIfQ1p5Y5R3trDtwocydt0KON1d'.freeze
  LOCATION_KEY = 28143.freeze # Dhaka city
  API_PATH = 'https://dataservice.accuweather.com'.freeze
  CURRENT_CONDITION_PATH = "currentconditions/v1/#{LOCATION_KEY}".freeze
  PAST_24_HOURS_CONDITION_PATH = "#{CURRENT_CONDITION_PATH}/historical/24".freeze
  PAST_6_HOURS_CONDITION_PATH = "#{CURRENT_CONDITION_PATH}/historical".freeze

  class << self
    def current
      send_request(CURRENT_CONDITION_PATH)
    end

    def past_24_hours
      send_request(PAST_24_HOURS_CONDITION_PATH)
    end

    def past_6_hours
      send_request(PAST_6_HOURS_CONDITION_PATH)
    end

    private

    def send_request(path)
      url = "#{API_PATH}/#{path}?apikey=#{API_KEY}"
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      JSON.parse(res.body)
    end
  end
end
