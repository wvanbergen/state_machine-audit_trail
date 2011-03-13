# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "state_machine_logger"
  s.version     = "0.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Willem van Bergen"]
  s.email       = ["willem@shopify.com"]
  s.homepage    = ""
  s.summary     = %q{Log transitions on a state machine to allow analytics.}
  s.description = %q{Log transitions on a state machine to allow analytics.}

  s.rubyforge_project = "state_machine_logger"

  s.add_runtime_dependency('state_machine')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2')
  s.add_development_dependency('activemodel', '~> 3')

  s.files      = %w{}
  s.test_files = %w{}
end
