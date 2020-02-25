#!/usr/bin/env ruby

require 'lsystem'


# Lindenmayer's original L-system for modelling the growth of algae.
#
#     variables : A B
#     constants : none
#     axiom : A
#     rules : (A → AB), (B → A)
#
algae = LSystem.declare do

	variables :A, :B
	axiom 'A'
	rules 'A -> AB',
		'B -> A'

end


iter = algae.each
8.times do |i|
	puts "n = %d : %s" % [ i, iter.next ]
end

# -or-

LSystem.run( algae, 8 ) do

	production_map \
		'A' => :print_a,
		'B' => :print_b

	def print_a
		print 'A'
	end

	def print_b
		print 'B'
	end

end

# n = 1 : AB
# n = 2 : ABA
# n = 3 : ABAAB
# n = 4 : ABAABABA
# n = 5 : ABAABABAABAAB
# n = 6 : ABAABABAABAABABAABABA
# n = 7 : ABAABABAABAABABAABABAABAABABAABAAB


