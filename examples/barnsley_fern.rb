#!/usr/bin/env ruby

require 'loggability'
require 'tortoise'
require 'l_system'

require_relative 'tortoise_monkeypatches'

Loggability.level = :error
Loggability.format_with( :color )


# Barnsley fern
#
#   - variables : X F
#   - constants : + − [ ]
#   - axiom : X
#   - rules : (X → F+[[X]-X]-F[-FX]+X), (F → FF)
#   - angle : 25°
#
fern = LSystem.declare do

	variables 'X', 'F'
	constants '+', '-', '[', ']'
	axiom 'X'
	rules \
		'X → F+[[X]-X]-F[-FX]+X',
		'F → FF'

end

# puts ">>> Manual iteration: "
# iter = fern.each
# 8.times do |i|
# 	puts "n = %d : %s" % [ i, iter.next ]
# end

LSystem.run( fern, 8 ) do
	extend Loggability
	log_to :l_system


	# The size of the canvas to draw on
	CANVAS_SIZE = 2000

	# F: draw forward
	# X : no-op
	# -: turn left 25°
	# +: turn right 25°
	# [: push position and angle
	# ]: pop position and angle
	production_map \
		'F' => :forward,
		'-' => :turn_left,
		'+' => :turn_right,
		'[' => :save_pos_and_angle,
		']' => :restore_pos_and_angle

	### Set up some instance variables
	def initialize( * )
		super
		@turtle = nil
		@positions = []
	end


	on_start do |i, _|
		@turtle = Tortoise::Interpreter.new( CANVAS_SIZE )
		@turtle.setpos( CANVAS_SIZE / 2, 0 )
		@turtle.direction = 90
		@turtle.pd
	end


	on_finish do |i, _|
		File.open( "fern_gn#{i}.png", File::WRONLY|File::TRUNC|File::CREAT, 0644, encoding: 'binary' ) do |fh|
			fh.write( @turtle.to_png )
		end
	end


	### Draw a line forward
	def forward
		self.log.debug "Forward 5 from %p at %p angle" % [ @turtle.position, @turtle.direction ]
		@turtle.fd( 5 )
	end


	### Turn 25° to the left
	def turn_left
		@turtle.lt( 25 )
	end


	### Turn 25° to the right
	def turn_right
		@turtle.rt( 25 )
	end


	### Save the drawing position and angle
	def save_pos_and_angle
		self.log.debug "Saving position and angle: %p + %p" % [ @turtle.position, @turtle.direction ]
		@positions.push([ @turtle.position, @turtle.direction ])
	end


	### Restore the next saved position and angle
	def restore_pos_and_angle
		to_restore = @positions.pop or raise IndexError, "Position stack underflow"
		self.log.debug "Restoring position and angle: %p + %p" % to_restore

		@turtle.setpos( *to_restore.first )
		@turtle.direction = to_restore.last
	end

end

