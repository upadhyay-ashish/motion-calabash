# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'motion-calabash'
  s.summary = 'Calabash integration for RubyMotion projects.'
  s.description = 'motion-calabash allows testing RubyMotion projects with Calabash iOS.'
  s.author = 'Karl Krukow'
  s.email = 'karl@lesspainful.com'
  s.homepage = 'http://www.lesspainful.com'
  s.version = '0.0.2'
  s.summary = %q{Calabash support for RubyMotion}
  s.description = %q{This will download and link-in calabash}
  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("calabash-cucumber", "0.9.107")

end
