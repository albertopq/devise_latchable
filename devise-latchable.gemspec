# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "devise_latchable"
  s.version     = 0.1
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ["MIT"]
  s.summary     = "Devise extension that integrates with Latch"
  s.email       = "alberto@pastor.bz"
  s.homepage    = "https://github.com/albertopq/devise_latchable"
  s.description = "Devise extension that allows you to block login attempts depending on Latch (http://latch.elevenpaths.com/) status"
  s.authors     = ['Alberto Pastor']

  s.rubyforge_project = "devise_latchable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency("devise", "~> 3.0")
  s.add_dependency("latchsdk", "~> 1.1")
end
