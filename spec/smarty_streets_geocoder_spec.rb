require 'spec_helper'

describe Geokit::Geocoders::SmartyStreetsGeocoder do

  let(:address) { Geokit::GeoLoc.new(city: "Sunnyvale", state: "CA", country_code: "US") }

  subject { described_class.geocode(address) }

  context "when missing credentials" do

    it 'raises an error' do
      expect { subject }.to raise_error Geokit::Geocoders::GeocodeError
    end
  end

  context "with invalid credentials" do

    before do
      Geokit::Geocoders::SmartyStreetsGeocoder.auth_id = "test"
      Geokit::Geocoders::SmartyStreetsGeocoder.auth_token = "fake"
    end

    it 'returns invalid location' do
      VCR.use_cassette("permission_denied") do
        expect( subject.success? ).to be false
      end
    end
  end

  context "with correct credentials" do

    before do
      Geokit::Geocoders::SmartyStreetsGeocoder.auth_id = ENV['SMARTYSTREETS_AUTH_ID']
      Geokit::Geocoders::SmartyStreetsGeocoder.auth_token = ENV['SMARTYSTREETS_AUTH_TOKEN']
    end

    it 'not raises an error' do
      VCR.use_cassette("sunnyvale_location") do
        expect { subject }.not_to raise_error
      end
    end

    it 'returns valid location' do
      VCR.use_cassette("sunnyvale_location") do
        expect( subject.success?     ).to be true
        expect( subject.city         ).to eq "Sunnyvale"
        expect( subject.state_name   ).to eq "California"
        expect( subject.state_code   ).to eq "CA"
        expect( subject.state        ).to eq "CA"
        expect( subject.zip          ).to eq "94085"
        expect( subject.country_code ).to eq "US"
        expect( subject.lat          ).to eq 37.38943
        expect( subject.lng          ).to eq -122.01811
      end
    end

    context "string address" do

      let(:address) { "Gilbert, AZ 85297 US" }

      it 'returns valid location' do
        VCR.use_cassette("arizona_location") do
          expect( subject.success?     ).to be true
          expect( subject.city         ).to eq "Gilbert"
          expect( subject.state_name   ).to eq "Arizona"
          expect( subject.state_code   ).to eq "AZ"
          expect( subject.state        ).to eq "AZ"
          expect( subject.zip          ).to eq "85297"
          expect( subject.country_code ).to eq "US"
          expect( subject.lat          ).to eq 33.27696
          expect( subject.lng          ).to eq -111.71752
        end
      end

    end

    context "not US location" do

      let(:address) { Geokit::GeoLoc.new(city: "Vancouver", state: "BC", country_code: "CA") }

      it 'returns invalid location' do
        expect( subject.success? ).to be false
      end

    end

  end

end
