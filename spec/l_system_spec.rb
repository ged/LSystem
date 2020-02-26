# -*- ruby -*-
# frozen_string_literal: true

require_relative 'spec_helper'

require 'rspec'
require 'l_system'

RSpec.describe( LSystem ) do

	it "allows an L-System to be declared" do
		result = described_class.declare {}
		expect( result ).to be_an( LSystem::RulesEngine )
	end


	it "can run an L-System within the context of one or more productions" do
		rules = described_class.declare do
			variables :A, :B
			axiom 'A'
			rules 'A -> AB',
				'B -> A'
		end
		result = described_class.run( rules, 8 ) do

			production_map \
				'A' => :append_A,
				'B' => :append_B

			on_start do |_generation_number, _previous_result|
				@output = String.new( encoding: 'utf-8' )
			end

			result do |_generation_number|
				@output
			end

			on_finish do |_generation_number, _result|
				@output = nil
			end


			def initialize
				@output = nil
			end

			def append_A
				@output << 'A'
			end

			def append_B
				@output << 'B'
			end

		end

		expect( result ).to eq( 'ABAABABAABAABABAABABAABAABABAABAAB' )
	end

end

