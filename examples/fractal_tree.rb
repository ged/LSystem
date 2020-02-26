#!/usr/bin/env ruby

require 'tortoise'
require 'lsystem'

# Add some functionality to the Tortoise interpreter
module TortoiseInterpreterHacks
	def direction=( new_direction )
		@direction = new_direction
	end
end
Tortoise::Interpreter.prepend( TortoiseInterpreterHacks )


# Lindenmayer's original L-system for modelling the growth of algae.
#
#   - variables : 0, 1
#   - constants: [, ]
#   - axiom : 0
#   - rules : (1 → 11), (0 → 1[0]0)
#
fractal_tree = LSystem.declare do

	variables '0', '1'
	constants '[', ']'
	axiom '0'
	rules \
		'1 -> 11',
		'0 -> 1[0]0'

end


LSystem.run( fractal_tree, 9 ) do

    # 0: draw a line segment ending in a leaf
    # 1: draw a line segment
    # [: push position and angle, turn left 45 degrees
    # ]: pop position and angle, turn right 45 degrees
	production_map \
		'0' => :draw_leaf,
		'1' => :draw_branch,
		'[' => :push_and_turn,
		']' => :pop_and_turn

	### Set up some instance variables
	def initialize( * )
		super
		@turtle = nil
		@positions = []
	end


	on_start do |i, _|
		@turtle = Tortoise::Interpreter.new( 1024 )
		@turtle.setpos( 512, 0 )
		@turtle.pd
	end


	on_finish do |i, _|
		File.open( "fractal_tree_gen#{i}.png", File::WRONLY|File::TRUNC|File::CREAT, 0644, encoding: 'binary' ) do |fh|
			fh.write( @turtle.to_png )
		end
	end


	### Draw a line segment with a leaf.
	def draw_leaf
		@turtle.fd( 6 )
		@turtle.rt( 90 )
		@turtle.fd( 3 )
		@turtle.lt( 90 )
		@turtle.fd( 6 )
		@turtle.lt( 90 )
		@turtle.fd( 6 )
		@turtle.lt( 90 )
		@turtle.fd( 6 )
		@turtle.lt( 90 )
		@turtle.fd( 3 )
		@turtle.lt( 180 )
	end


	### Draw a line segment
	def draw_branch
		@turtle.fd( 3 )
	end


	### Push position and angle, turn left 45 degrees
	def push_and_turn
		@positions.push([ @turtle.position, @turtle.direction ])
		@turtle.lt( 45 )
	end


	### Pop position and angle, turn right 45 degrees
	def pop_and_turn
		to_restore = @positions.pop or raise IndexError, "Position stack underflow"

		@turtle.setpos( *to_restore.first )
		@turtle.direction = to_restore.last
		@turtle.rt( 45 )
	end

end

