#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'lsystem/rules_engine'


RSpec.describe( LSystem::RulesEngine ) do

	let( :instance ) { described_class.new }


	it "can set the l-system's variables" do
		instance.variables = [ 'A', 'B' ]

		expect( instance.variables ).to contain_exactly( 'A', 'B' )
	end


	it "can declare the l-system's variables" do
		instance.variables 'A', 'B'

		expect( instance.variables ).to contain_exactly( 'A', 'B' )
	end


	it "raises if variables are not disjoint with the constants" do
		instance.variables 'A', 'B'
		expect {
			instance.constants '[', 'A', ']'
		}.to raise_error( ArgumentError, /"A" is already included in the variable set/ )
	end


	it "can set the l-system's constants'" do
		instance.constants = [ '[', ']' ]

		expect( instance.constants ).to contain_exactly( '[', ']' )
	end


	it "can declare the l-system's constants'" do
		instance.constants '[', ']'

		expect( instance.constants ).to contain_exactly( '[', ']' )
	end


	it "raises if constants are not disjoint with the variables" do
		instance.constants '[', 'A', ']'
		expect {
			instance.variables 'A', 'B'
		}.to raise_error( ArgumentError, /"A" is already included in the constant set/ )
	end


	it "knows what its alphabet is" do
		instance.variables '0', '1'
		instance.constants '[', ']'

		expect( instance.alphabet ).to contain_exactly( '0', '1', '[', ']' )
	end


	it "can apply its rules to a string" do
		instance.variables 'A', 'B'
		instance.rules 'A -> AB', 'B -> A'

		expect( instance.apply_rules('A') ).to eq( 'AB' )
		expect( instance.apply_rules('AB') ).to eq( 'ABA' )
		expect( instance.apply_rules('ABA') ).to eq( 'ABAAB' )
		expect( instance.apply_rules('ABAAB') ).to eq( 'ABAABABA' )
		expect( instance.apply_rules('ABAABABA') ).to eq( 'ABAABABAABAAB' )
		expect( instance.apply_rules('ABAABABAABAAB') ).to eq( 'ABAABABAABAABABAABABA' )
		expect( instance.apply_rules('ABAABABAABAABABAABABA') ).
			to eq( 'ABAABABAABAABABAABABAABAABABAABAAB' )
	end


	it "can create an enumerator that will yield each successive generation" do
		instance.variables 'A', 'B'
		instance.axiom 'A'
		instance.rules 'A -> AB', 'B -> A'

		result = instance.each

		expect( result ).to be_an( Enumerator )
		expect( result.next ).to eq( 'A' )
		expect( result.next ).to eq( 'AB' )
		expect( result.next ).to eq( 'ABA' )
		expect( result.next ).to eq( 'ABAAB' )
		expect( result.next ).to eq( 'ABAABABA' )
		expect( result.next ).to eq( 'ABAABABAABAAB' )
		expect( result.next ).to eq( 'ABAABABAABAABABAABABA' )
		expect( result.next ).to eq( 'ABAABABAABAABABAABABAABAABABAABAAB' )
	end

end

