require "geokit"

module Geokit
  module Geocoders
    class SmartyStreetsGeocoder < Geocoder

      API_ENDPOINT = "https://us-zipcode.api.smartystreets.com/lookup"

      config :auth_id, :auth_token

      private

      # Template method which does the geocode lookup.
      def self.do_geocode(address, options = {})

        if (auth_id.nil? || auth_id.empty?) || (auth_token.nil? || auth_token.empty?)
          raise(Geokit::Geocoders::GeocodeError, "SmartyStreets requires auth id and token to use their service.")
        end

        address = address.is_a?(GeoLoc) ? address : parse_address(address)

        return address unless address.is_us?

        process :json, submit_url(address), address
      end

      def self.submit_url(address)
        args = []
        args << "auth-id=#{Geokit::Inflector.url_escape(auth_id)}"
        args << "auth-token=#{Geokit::Inflector.url_escape(auth_token)}"

        args << "city=#{Geokit::Inflector.url_escape(address.city)}"   unless address.city.nil? || address.city.empty?
        args << "state=#{Geokit::Inflector.url_escape(address.state)}" unless address.state.nil? || address.state.empty?
        args << "zipcode=#{Geokit::Inflector.url_escape(address.zip)}" unless address.zip.nil? || address.zip.empty?

        [API_ENDPOINT, '?', args.join('&')].join('')
      end


      def self.parse_json(json, address)
        json = json.first

        return GeoLoc.new if json.has_key?('status') # means error

        new_loc.tap do |loc|
          loc.street_address = address.street_address
          loc.province       = address.province
          loc.country_code   = address.country_code

          city_state = json["city_states"].first

          loc.city           = city_state["city"]
          loc.state_code     = city_state["state_abbreviation"]
          loc.state_name     = city_state["state"]

          zipcode = detect_zipcode(json, loc.city)

          loc.zip = zipcode["zipcode"]
          loc.lat = zipcode["latitude"]
          loc.lng = zipcode["longitude"]

          loc.success = true
        end
      end

      def self.detect_zipcode(json, city)
        json["zipcodes"].detect { |zc| zc["default_city"] == city } || json["zipcodes"].first
      end

      # Expects address line in format: street_address, province, city, state, zip, country
      def self.parse_address(address_string)
        address_parts = address_string.split(',').map(&:strip)
        GeoLoc.new(
          street_address: address_parts[0],
          province: address_parts[1],
          city: address_parts[2],
          state: address_parts[3],
          zip: address_parts[4],
          country_code: address_parts[5]
        )
      end

    end
  end
end
