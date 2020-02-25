# -*- ruby -*-
# frozen_string_literal: true

require 'loggability'


# A toolkit for creating and using Lindenmayer Systems.
module LSystem
	extend Loggability

	# Package version
	VERSION = '0.0.1'

	# Version control revision
	REVISION = %q$Revision$


	# Loggability API -- set up a logger for lsystem
	log_as :lsystem


	autoload :RulesEngine, 'lsystem/rules_engine'
	autoload :ProductionAdapter, 'lsystem/production_adapter'


	### Declare a new L-System that is configured via the given +block+.
	def self::declare( &block )
		return LSystem::RulesEngine.new( &block )
	end


	### Run a +rules_engine+ at most the given number of +iterations+ using the productions
	### declared in the +block+, which runs in the context of an anonymous
	### LSystem::ProductionAdapter class.
	def self::run( rules_engine, iterations=1000, &block )
		raise LocalJumpError, "no block given" unless block

		adapter = Class.new( LSystem::ProductionAdapter, &block )
		return adapter.new.run( rules_engine, iterations )
	end

end # module LSystem

