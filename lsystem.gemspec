# -*- encoding: utf-8 -*-
# stub: lsystem 0.2.0.pre.20200226141113 ruby lib

Gem::Specification.new do |s|
  s.name = "lsystem".freeze
  s.version = "0.2.0.pre.20200226141113"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze]
  s.date = "2020-02-26"
  s.description = "A toolkit for creating and using {Lindenmayer Systems}[https://en.wikipedia.org/wiki/L-system] (L-systems).\nIt consists of a class that allows for declaration of the L-system's grammar,\nand another class that allows for the definition of how the symbols output by a\ngrammar should be translated into work.".freeze
  s.email = ["ged@faeriemud.org".freeze]
  s.files = [".simplecov".freeze, "History.md".freeze, "README.md".freeze, "Rakefile".freeze, "examples/fern_gn7.png".freeze, "lib/lsystem.rb".freeze, "lib/lsystem/production_adapter.rb".freeze, "lib/lsystem/rules_engine.rb".freeze, "spec/lsystem/production_adapter_spec.rb".freeze, "spec/lsystem/rules_engine_spec.rb".freeze, "spec/lsystem_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "https://hg.sr.ht/~ged/LSystem".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "A toolkit for creating and using {Lindenmayer Systems}[https://en.wikipedia.org/wiki/L-system] (L-systems).".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<loggability>.freeze, ["~> 0.16"])
    s.add_development_dependency(%q<tortoise>.freeze, ["~> 0.9"])
    s.add_development_dependency(%q<rake-deveiate>.freeze, ["~> 0.10"])
  else
    s.add_dependency(%q<loggability>.freeze, ["~> 0.16"])
    s.add_dependency(%q<tortoise>.freeze, ["~> 0.9"])
    s.add_dependency(%q<rake-deveiate>.freeze, ["~> 0.10"])
  end
end
