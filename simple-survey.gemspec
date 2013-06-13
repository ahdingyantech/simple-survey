# coding: utf-8
Gem::Specification.new do |s|
  s.name = 'simple-survey'
  s.version = '0.0.0'
  s.platform = Gem::Platform::RUBY
  s.date = '2013-06-13'
  s.summary = 'simple-survey'
  s.description = 'simple-survey'
  s.authors = ['ben7th', 'fushang318']
  s.email = 'ben7th@sina.com'
  s.homepage = 'https://github.com/mindpin/simple-survey'
  s.licenses = 'MIT'
  s.files = Dir.glob("lib/**/*") + %w(README.md)
  s.require_paths = ['lib']

  s.add_dependency('roo', '1.10.3')
  s.add_dependency('iconv', '1.0.2')
end