# -*- ruby -*-
# frozen_string_literal: true

require 'set'
require 'loggability'

require 'lsystem' unless defined?( LSystem )


# An engine for iterating over successive applications of the L-System's
# ruleset to its axiom.
class LSystem::RulesEngine
	extend Loggability


	# Loggability API -- log to the lsystem logger
	log_to :lsystem


	### Create a new rules engine for an L-System. If the +block+ is present,
	### it is called with the new instance as +self+.
	def initialize( &block )
		@variables = Set.new
		@constants = Set.new
		@axiom = nil
		@rules = []

		@rules_as_hash = nil

		self.instance_eval( &block ) if block
	end


	######
	public
	######

	#
	# DSL Methods
	#

	### Get/set the system's variables (the replaceable parts of its alphabet).
	def variables( *new_values )
		self.variables = new_values unless new_values.empty?
		return @variables.dup
	end


	### Set the systems variables to +new_values+.
	def variables=( new_values )
		@rules_as_hash = nil

		new_values = Set.new( new_values, &:to_s )
		unless new_values.disjoint?( self.constants )
			common_char = (new_values & self.constants).to_a.first
			raise ArgumentError, "%p is already included in the constant set" % [ common_char ]
		end

		@variables = new_values
	end


	### Get/set the system's constants (the static parts of its alphabet).
	def constants( *new_values )
		self.constants = new_values unless new_values.empty?
		return @constants.dup
	end


	### Set the systems constants to +new_values+.
	def constants=( new_values )
		@rules_as_hash = nil

		new_values = Set.new( new_values, &:to_s )
		unless new_values.disjoint?( self.variables )
			common_char = (new_values & self.variables).to_a.first
			raise ArgumentError, "%p is already included in the variable set" % [ common_char ]
		end

		@constants = new_values
	end


	### Return the system's variables and constants.
	def alphabet
		return @variables | @constants
	end


	### Get/set the axiom of the system.
	def axiom( new_value=nil )
		self.axiom = new_value if new_value
		return @axiom
	end


	### Set the axiom of the system.
	def axiom=( new_value )
		@axiom = new_value
	end


	### Get/set the system's rules.
	def rules( *new_values )
		self.rules = new_values unless new_values.empty?
		return @rules
	end


	### Set the system's rules.
	def rules=( new_values )
		@rules_as_hash = nil
		@rules = Array( new_values ).map( &:to_s )
	end


	#
	# Iteration API
	#

	### Apply the system's rules to the given +state+ and return the result.
	def apply_rules( state )
		rules_hash = self.rules_as_hash
		return state.each_char.with_object( String.new(encoding: 'utf-8') ) do |char, new_state|
			new_state << rules_hash[ char ]
		end
	end


	### Yield each successive generation to the given +block+, or return an
	### Enumerator that will do so if no block is given.
	def each( &block )
		iter = Enumerator.new do |yielder|
			state = new_state = self.axiom.dup

			begin
				yielder.yield( new_state )
				state = new_state
				new_state = self.apply_rules( state )
			end until state == new_state
		end

		return iter unless block
		return iter.each( &block )
	end


	#########
	protected
	#########

	### Return a Hash of tranforms that should be applied to a state during a
	### generation.
	def rules_as_hash
		unless @rules_as_hash
			@rules_as_hash = self.rules.each_with_object( {} ) do |rule, hash|
				pred, succ = self.parse_rule( rule )
				hash[ pred ] = succ
			end

			self.alphabet.each do |char|
				@rules_as_hash[ char ] = char unless @rules_as_hash.key?( char )
			end
		end

		return @rules_as_hash
	end


	### Return a tuple of the predecessor and successor of the given +rule+.
	def parse_rule( rule )
		predecessor, successor = rule.strip.split( /\s*->\s*/, 2 )
		successor_set = Set.new( successor.chars )

		raise "Invalid rule: predecessor %p is not in the variable set %p" %
			[ predecessor, self.variables ] unless self.variables.include?( predecessor )
		raise "Invalid rule: successor %p contains characters not in the alphabet %p" %
			[ successor, self.alphabet ] unless self.alphabet.superset?( successor_set )

		return predecessor, successor
	end

end # class LSystem::RulesEngine

