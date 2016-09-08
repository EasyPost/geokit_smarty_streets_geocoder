require "uri"
require "geokit"
require "Indirizzo"
require "countries"

module Geokit
  module Geocoders
    class SmartyStreetsGeocoder < Geocoder

      API_ENDPOINT = "https://us-zipcode.api.smartystreets.com/lookup".freeze

      config :auth_id, :auth_token

      private

      def self.do_geocode(address, options = {})

        if (auth_id.nil? || auth_id.empty?) || (auth_token.nil? || auth_token.empty?)
          raise(Geokit::Geocoders::GeocodeError, "SmartyStreets requires auth id and token to use their service.")
        end

        address = address.is_a?(GeoLoc) ? address : parse_address(address)

        return GeoLoc.new unless address.is_us?

        process :json, submit_url(address), address
      end

      def self.submit_url(address)
        args = []
        args << ["auth-id", auth_id]
        args << ["auth-token", auth_token]

        args << ["city", address.city]
        args << ["state", address.state]
        args << ["zipcode", address.zip]

        [API_ENDPOINT, '?', URI.encode_www_form(args)].join('')
      end


      def self.parse_json(json, address)
        json = json.first

        return GeoLoc.new if json.has_key?('status') # means error

        address.provider = Geokit::Inflector.underscore(provider_name)

        if city_state = json["city_states"].first
          address.city           = city_state["city"]
          address.state_code     = city_state["state_abbreviation"]
          address.state_name     = city_state["state"]
        end

        if zipcode = detect_zipcode(json, address.city)
          address.zip = zipcode["zipcode"]
          address.lat = zipcode["latitude"]
          address.lng = zipcode["longitude"]
        end

        address.success = true

        address
      end

      def self.detect_zipcode(json, city)
        json["zipcodes"].detect { |zc| zc["default_city"] == city } || json["zipcodes"].first
      end

      def self.parse_address(address_string)
        address = Indirizzo::Address.new(address_string, expand_streets: false)

        loc = GeoLoc.new
        loc.street_number = address.street.join(' ')
        loc.street_name = address.number
        loc.city = address.city
        loc.state = address.state
        loc.zip = address.zip

        if country = ::ISO3166::Country.find_country_by_alpha2(address.country) || ::ISO3166::Country.find_country_by_name(address.country)
          loc.country_code = country.try(:alpha2)
          loc.country = country.try(:name) || address.country
        end

        loc
      end

    end
  end
end
