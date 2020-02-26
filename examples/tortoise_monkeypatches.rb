# -*- ruby -*-
# frozen_string_literal: true

require 'tortoise'


# Patches for some stuff in Tortoise
module TortoiseInterpreterHacks

	### Allow the direction to be set directly
	def direction=( new_direction )
		@direction = new_direction
	end


	### Allow the direction to be set to angles other than those on the 45° 
	### axes.
	def walk( steps )
		x, y  = @position
		theta = @direction * Math::PI / 180

		1.upto( steps.abs ) do
			x += Math::cos( theta )
			y += Math::sin( theta )

			update_position( x, y )
		end
	end

end # module TortoiseInterpreterHacks

Tortoise::Interpreter.prepend( TortoiseInterpreterHacks )


