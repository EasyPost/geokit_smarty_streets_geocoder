[![Gem Version](https://badge.fury.io/rb/smarty_streets_geocoder.svg)](https://badge.fury.io/rb/smarty_streets_geocoder)
[![Build Status](https://travis-ci.org/srozum/smarty_streets_geocoder.svg?branch=master)](https://travis-ci.org/srozum/smarty_streets_geocoder)

# SmartyStreetsGeocoder

Custom [geokit](https://github.com/geokit/geokit) geocoder for [SmartyStreets](https://smartystreets.com) address verification service.

This geocoder works for US addressed only.

[API Documentation](https://smartystreets.com/docs/us-zipcode-api)

## Installation

Add this line to your application's Gemfile:

    gem 'smarty_streets_geocoder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smarty_streets_geocoder

## Configuration


```ruby
    # This is your SmartyStreets application key for the SmartyStreets Geocoder.
    # See https://smartystreets.com/docs/authentication#keypairs
    Geokit::Geocoders::SmartyStreetsGeocoder.auth_id = 'REPLACE_WITH_YOUR_KEY'
    Geokit::Geocoders::SmartyStreetsGeocoder.auth_token = 'REPLACE_WITH_YOUR_CODE'
```


## Usage

```ruby
    # use :smarty_streets to specify this geocoder in your list of geocoders.
    Geokit::Geocoders::SmartyStreetsGeocoder.geocode("Sunnyvale, CA")
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/smarty_streets_geocoder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
