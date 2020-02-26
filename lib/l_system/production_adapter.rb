# -*- ruby -*-
# frozen_string_literal: true

require 'loggability'

require 'l_system' unless defined?( LSystem )


# An adapter that connects method calls to an LSystem::RulesEngine's
# generations.
class LSystem::ProductionAdapter
	extend Loggability


	# Loggability API -- log to the l_system logger
	log_to :l_system


	### Inheritance callback -- add class-instance variables to the +subclass+.
	def self::inherited( subclass )
		super

		subclass.instance_variable_set( :@production_map, {} )
		subclass.instance_variable_set( :@callbacks, {} )
	end


	#
	# DSL Methods
	#

	### Declare a Hash of symbols to methods that should be called when one appears
	### in a generation.
	def self::production_map( productions={} )
		unless productions.empty?
			self.production_map = productions
		end

		return @production_map
	end


	### Set the Hash of symbols to methods that should be called when one appears in
	### a generation.
	def self::production_map=( new_map )
		@production_map.replace( new_map )
	end


	### Register a callback that will be called at the start of each new generation.
	### It will be called with the result of the last generation, or +nil+ if this
	### is the 0th (axiom) generation.
	def self::on_start( &block )
		self.log.debug "Declaring on_start callback: %p" % [ block ]
		define_method( :on_start, &block )
	end


	### Register a callback that will be called to obtain the result of running a
	### generation. The result of calling the +block+ will be passed to this
	### generation's #on_finish callback (if there is one), the next generation's
	### #on_start callback (if there is one and there's successive geneation), and
	### returned from #run if this was the last generation.
	def self::result( &block )
		self.log.debug "Declaring result callback: %p" % [ block ]
		define_method( :result, &block )
	end


	### Register a callback that will be called at the end of each new generation.
	### It will be called with the result of the this generation, which will be
	### +nil+ if no #result callback is declared.
	def self::on_finish( &block )
		self.log.debug "Declaring on_finish callback: %p" % [ block ]
		define_method( :on_finish, &block )
	end


	#
	# Instance methods
	#

	### Create a new instance of the ProductionAdapter.
	def initialize
		@production_map = self.class.production_map
	end


	######
	public
	######

	##
	# The map of symbols to production methods
	attr_reader :production_map


	### Run productions for each generation produced by the given +rules_engine+ up to
	### +iterations+ times.
	def run( rules_engine, iterations )
		self.log.debug "Running %p for up to %d iterations" % [ rules_engine, iterations ]

		return rules_engine.each.with_index.inject( nil ) do |result, (generation, i)|
			self.log.debug "Running generation %d" % [ i ]
			self.on_start( i, result ) if self.respond_to?( :on_start )
			self.run_generation( generation )
			result = self.result( i ) if self.respond_to?( :result )
			self.log.debug "Result [%d] is: %p" % [ i, result ]
			self.on_finish( i, result ) if self.respond_to?( :on_finish )

			break result if i >= iterations - 1
			result
		end
	end


	### Run the specified +generation+ by calling productions for each of its
	### symbols.
	def run_generation( generation )

		# Make a new one every time to support self-mutating adapters
		dispatch_table = self.make_dispatch_table

		generation.each_char do |symbol|
			callback = dispatch_table[ symbol ]

			unless callback
				self.log.warn "No production for symbol %p" % [ symbol ]
				next
			end

			self.log.debug "%p -> %p" % [ symbol, callback ]
			callback.call
		end
	end


	### Return a Hash of symbols to bound Methods to call for their productions from
	### the current #production_map.
	def make_dispatch_table
		return self.class.production_map.each_with_object( {} ) do |(symbol, method_name), hash|
			hash[ symbol ] = self.method( method_name )
		end
	end

end # class LSystem::ProductionAdapter

