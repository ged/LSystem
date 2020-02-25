# -*- ruby -*-
# frozen_string_literal: true

require_relative 'spec_helper'

require 'rspec'
require 'lsystem'

RSpec.describe LSystem do

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

			on_start do
				@output = String.new( encoding: 'utf-8' )
			end

			result do
				@output
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
	end

end

