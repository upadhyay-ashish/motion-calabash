# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'motion-calabash'
  s.summary = 'Calabash integration for RubyMotion projects.'
  s.description = 'motion-calabash allows testing RubyMotion projects with Calabash iOS.'
  s.author = 'Karl Krukow'
  s.email = 'karl.krukow@xamarin.com'
  s.homepage = 'http://www.xamarin.com'
  s.version = '0.9.160'
  s.summary = %q{Calabash support for RubyMotion}
  s.description = %q{This linkes-in calabash for iOS}
  s.files = ["lib/framework/libcalabashuni-0.9.160.a"].concat(`git ls-files`.split("\n"))
  s.require_paths = ["lib"]

  s.add_dependency("calabash-cucumber", "0.9.160")

end
