ENV['RAKE_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'smarty_streets_geocoder'

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data('<SMARTYSTREETS_AUTH_ID>') { ENV['SMARTYSTREETS_AUTH_ID'] }
  config.filter_sensitive_data('<SMARTYSTREETS_AUTH_TOKEN>') { ENV['SMARTYSTREETS_AUTH_TOKEN'] }
end
