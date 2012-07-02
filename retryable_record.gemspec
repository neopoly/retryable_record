# -*- encoding: utf-8 -*-
require File.expand_path('../lib/retryable_record/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Peter Suschlik"]
  gem.email         = ["ps@neopoly.de"]
  gem.description   = %q{Retries an operation on an ActiveRecord until no StaleObjectError is being raised.}
  gem.summary       = %q{Retries an operation on an ActiveRecord until no StaleObjectError is being raised.}
  gem.homepage      = "https://github.com/neopoly/retryable_record"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "retryable_record"
  gem.require_paths = ["lib"]
  gem.version       = RetryableRecord::VERSION

  gem.add_runtime_dependency 'activerecord', '>= 3'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest', '~> 3.2.0'
end
