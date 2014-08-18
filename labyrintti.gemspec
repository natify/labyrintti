# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'labyrintti/version'

Gem::Specification.new do |gem|
  gem.name          = 'labyrintti'
  gem.version       = Labyrintti::VERSION
  gem.authors       = ['Alexander Simonov']
  gem.email         = ['alex@simonov.me']
  gem.summary       = %q{Labirintti SMS Gateway HTTP Interface wrapper}
  gem.description   = %q{Labirintti SMS Gateway HTTP Interface wrapper}
  gem.homepage      = 'https://github.com/dotpromo/labirintti_sms'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('faraday')
  gem.add_dependency('activesupport', '>= 4', '< 5')
  gem.add_development_dependency('bundler', '~> 1.6')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec', '>= 3.0')
  gem.add_development_dependency('webmock')
end
