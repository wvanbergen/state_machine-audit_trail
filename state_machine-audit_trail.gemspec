# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "state_machine-audit_trail"
  s.version     = "0.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Willem van Bergen", "Jesse Storimer"]
  s.email       = ["willem@shopify.com", "jesse.storimer@shopify.com"]
  s.homepage    = "https://github.com/wvanbergen/state_machine-audit_trail"
  s.summary     = %q{Log transitions on a state machine to support auditing and business process analytics.}
  s.description = %q{Log transitions on a state machine to support auditing and business process analytics.}

  s.rubyforge_project = "state_machine"

  s.add_runtime_dependency('state_machine')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2')
  s.add_development_dependency('activerecord', '~> 3')
  s.add_development_dependency('sqlite3')

  s.files      = %w(.gitignore Gemfile Rakefile lib/state_machine/audit_trail.rb lib/state_machine/audit_trail/active_record.rb lib/state_machine/audit_trail/base.rb lib/state_machine/audit_trail/railtie.rb lib/state_machine/audit_trail/transition_logging.rb lib/state_machine/audit_trail_generator.rb spec/spec_helper.rb spec/state_machine/audit_trail_spec.rb state_machine-audit_trail.gemspec tasks/github_gem.rb)
  s.test_files = %w(spec/state_machine/audit_trail_spec.rb)
end
