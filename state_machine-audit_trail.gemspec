# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "state_machine-audit_trail"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Willem van Bergen", "Jesse Storimer"]
  s.email       = ["willem@shopify.com", "jesse@shopify.com"]
  s.homepage    = "https://github.com/wvanbergen/state_machine-audit_trail"
  s.summary     = %q{Log transitions on a state machine to support auditing and business process analytics.}
  s.description = %q{Log transitions on a state machine to support auditing and business process analytics.}

  s.rubyforge_project = "state_machine"

  s.add_runtime_dependency('state_machine')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2')
  s.add_development_dependency('activerecord', '~> 3')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('mongoid')
  s.add_development_dependency('bson_ext')

  s.files      = %w(.gitignore .travis.yml Gemfile LICENSE README.rdoc Rakefile lib/state_machine-audit_trail.rb lib/state_machine/audit_trail.rb lib/state_machine/audit_trail/backend.rb lib/state_machine/audit_trail/backend/active_record.rb lib/state_machine/audit_trail/backend/mongoid.rb lib/state_machine/audit_trail/railtie.rb lib/state_machine/audit_trail/transition_auditing.rb lib/state_machine/audit_trail_generator.rb spec/helpers/active_record.rb spec/helpers/mongoid.rb spec/spec_helper.rb spec/state_machine/active_record_spec.rb spec/state_machine/audit_trail_spec.rb spec/state_machine/mongoid_spec.rb state_machine-audit_trail.gemspec tasks/github_gem.rb)
  s.test_files = %w(spec/state_machine/active_record_spec.rb spec/state_machine/audit_trail_spec.rb spec/state_machine/mongoid_spec.rb)
end
