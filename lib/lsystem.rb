# -*- ruby -*-
# frozen_string_literal: true

# A toolkit for creating and using Lindenmayer Systems.
module LSystem

	# Package version
	VERSION = '0.0.1'

	# Version control revision
	REVISION = %q$Revision$


	autoload :RulesEngine, 'lsystem/rules_engine'


	### Declare a new L-System that is configured via the given +block+.
	def self::declare( &block )
		return LSystem::RulesEngine.new( &block )
	end

end # module LSystem

