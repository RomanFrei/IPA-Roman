# -*- encoding: utf-8 -*-
require File.expand_path('../lib/skylogic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Roman Frei"]
  gem.email         = ["Roman.frei1@swisscom.com"]
  gem.description   = %q{Skylogic Erweiterung für IVO::Core}
  gem.summary       = %q{This Gem exchanges Data with the Skylogic Server}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "skylogic"
  gem.require_paths = ["lib"]
  gem.version       = Skylogic::VERSION
end
