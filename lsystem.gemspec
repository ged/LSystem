# -*- encoding: utf-8 -*-
# stub: lsystem 0.1.0.pre.20200222142004 ruby lib

Gem::Specification.new do |s|
  s.name = "lsystem".freeze
  s.version = "0.1.0.pre.20200222142004"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze]
  s.date = "2020-02-22"
  s.description = "A toolkit for creating and using [Lindenmayer Systems][lsystem] (L-systems).".freeze
  s.email = ["ged@faeriemud.org".freeze]
  s.files = [".simplecov".freeze, "ChangeLog".freeze, "README.md".freeze, "Rakefile".freeze, "lib/lsystem.rb".freeze, "spec/lsystem_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "https://hg.sr.ht/~ged/LSystem".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "A toolkit for creating and using [Lindenmayer Systems][lsystem] (L-systems).".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake-deveiate>.freeze, ["~> 0.10"])
  else
    s.add_dependency(%q<rake-deveiate>.freeze, ["~> 0.10"])
  end
end
