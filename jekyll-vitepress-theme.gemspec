require_relative 'lib/jekyll/vitepress_theme/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-vitepress-theme'
  spec.version       = Jekyll::VitePressTheme::VERSION
  spec.authors       = ['Carmine Paolino']
  spec.email         = ['carmine@paolino.me']

  spec.summary       = 'A VitePress-like docs theme for Jekyll.'
  spec.description   = 'Jekyll VitePress Theme brings the VitePress default theme look and behavior to Jekyll sites.'
  spec.homepage      = 'https://github.com/crmne/jekyll-vitepress-theme'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.1'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir[
    'assets/**/*',
    '_includes/**/*',
    '_layouts/**/*',
    'lib/**/*',
    'LICENSE*',
    'README.md'
  ].select { |f| File.file?(f) }

  spec.require_paths = ['lib']

  spec.add_dependency 'jekyll', '>= 4.3', '< 5.0'
end
