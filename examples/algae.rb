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


# n = 1 : AB
# n = 2 : ABA
# n = 3 : ABAAB
# n = 4 : ABAABABA
# n = 5 : ABAABABAABAAB
# n = 6 : ABAABABAABAABABAABABA
# n = 7 : ABAABABAABAABABAABABAABAABABAABAAB


puts ">>> Manual iteration: "
iter = algae.each
8.times do |i|
	puts "n = %d : %s" % [ i, iter.next ]
end

# -or-

puts "\n>>> Using a production adapter: "
LSystem.run( algae, 8 ) do

	production_map \
		'A' => :print_a,
		'B' => :print_b

	on_start do |i, *|
		print "n = #{i} : "
	end

	on_finish do |*|
		puts
	end

	def print_a
		print 'A'
	end

	def print_b
		print 'B'
	end

end

