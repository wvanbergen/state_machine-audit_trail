# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'state_machine/audit_trail/version'

Gem::Specification.new do |s|
  s.name        = "state_machine-audit_trail"
  s.version     = StateMachine::AuditTrail::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Willem van Bergen", "Jesse Storimer"]
  s.email       = ["willem@shopify.com", "jesse@shopify.com"]
  s.homepage    = "https://github.com/wvanbergen/state_machine-audit_trail"
  s.summary     = %q{Log transitions on a state machine to support auditing and business process analytics.}
  s.description = %q{Log transitions on a state machine to support auditing and business process analytics.}
  s.license     = "MIT"

  s.rubyforge_project = "state_machine"

  s.add_runtime_dependency('state_machine')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2')
  s.add_development_dependency('activerecord', '~> 3')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('mongoid', '~> 2')
  s.add_development_dependency('bson_ext')

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
end
