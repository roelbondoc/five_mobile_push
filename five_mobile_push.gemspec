# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "five_mobile_push/version"

Gem::Specification.new do |s|
  s.name        = "five_mobile_push"
  s.version     = FiveMobilePush::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kevin Faustino"]
  s.email       = ["kevin.faustino@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{API wrapper for Five Mobile Push notification service}
  s.description = %q{API wrapper for Five Mobile Push notification service}

  s.rubyforge_project = "five_mobile_push"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "hashie", ["~> 1.0.0"]
  s.add_dependency "multi_json", ["~> 0.0.5"]
  s.add_dependency "faraday", ["~> 0.5.7"]
  s.add_dependency "faraday_middleware", ["~> 0.3.2"]
  s.add_development_dependency "rspec", ["~> 2.5.0"]
  s.add_development_dependency "yajl-ruby"
  s.add_development_dependency "webmock"
end
