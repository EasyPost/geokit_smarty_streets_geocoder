# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "smarty_streets_geocoder"
  spec.version       = "0.0.2"
  spec.authors       = ["Serhiy Rozum"]
  spec.email         = ["sergey.rozum@gmail.com"]
  spec.summary       = %q{Geokit custom geocoder for SmartyStreets address verification service}
  spec.description   = %q{Geokit custom geocoder for SmartyStreets address verification service}
  spec.homepage      = "https://github.com/srozum/smarty_streets_geocoder.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "geokit"
  spec.add_dependency "Indirizzo"
  spec.add_dependency "countries"

end
