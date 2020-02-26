#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'l_system/production_adapter'


RSpec.describe( LSystem::ProductionAdapter ) do

	let( :algae_rules ) do
		LSystem.declare do
			variables :A, :B
			axiom 'A'
			rules \
				'A -> AB',
				'B -> A'
		end
	end


	describe "subclasses" do

		let( :subclass ) do
			Class.new( described_class ) do

				def initialize
					@calls = []
				end

				attr_reader :calls

				def method_missing( sym, *args )
					self.calls << sym
				end

				def respond_to_missing?( sym, include_all )
					return super if [:on_start, :result, :on_finish].include?( sym )
					return true
				end

			end
		end


		it "can declare a method map for its productions" do
			subclass.production_map \
				'A' => :do_a_thing,
				'B' => :do_b_thing

			instance = subclass.new
			instance.run_generation( 'AABA' )

			expect( instance.calls ).to eq([
				:do_a_thing,
				:do_a_thing,
				:do_b_thing,
				:do_a_thing,
			])
		end


		it "handles symbols that don't make good method names" do
			subclass.production_map \
				'[' => :push_frame,
				'A' => :report_depth,
				']' => :pop_frame

			instance = subclass.new
			instance.run_generation( 'A[A[[]]A[]]]]' )

			expect( instance.calls ).to eq([
				:report_depth,
				:push_frame,
				:report_depth,
				:push_frame,
				:push_frame,
				:pop_frame,
				:pop_frame,
				:report_depth,
				:push_frame,
				:pop_frame,
				:pop_frame,
				:pop_frame,
				:pop_frame
			])
		end


		it "can run a rules engine" do
			subclass.production_map \
				'A' => :report_a,
				'B' => :report_b

			instance = subclass.new
			instance.run( algae_rules, 4 )

			expect( instance.calls ).to eq([
				:report_a,

				:report_a,
				:report_b,

				:report_a,
				:report_b,
				:report_a,

				:report_a,
				:report_b,
				:report_a,
				:report_a,
				:report_b,
			])
		end


		it "can declare lifecycle callbacks" do
			subclass.production_map \
				'A' => :report_a,
				'B' => :report_b
			subclass.on_start do |i, previous_result|
				self.calls << [ :on_start, i, previous_result ]
			end
			subclass.result do |i|
				self.calls << [ :result, i ]
				"result_#{i}"
			end
			subclass.on_finish do |i, result|
				self.calls << [ :on_finish, i, result ]
			end

			instance = subclass.new
			result = instance.run( algae_rules, 4 )

			expect( instance.calls ).to eq([
				[:on_start, 0, nil],
				:report_a,
				[:result, 0],
				[:on_finish, 0, "result_0"],

				[:on_start, 1, "result_0"],
				:report_a,
				:report_b,
				[:result, 1],
				[:on_finish, 1, "result_1"],

				[:on_start, 2, "result_1"],
				:report_a,
				:report_b,
				:report_a,
				[:result, 2],
				[:on_finish, 2, "result_2"],

				[:on_start, 3, "result_2"],
				:report_a,
				:report_b,
				:report_a,
				:report_a,
				:report_b,
				[:result, 3],
				[:on_finish, 3, "result_3"],
			])

			expect( result ).to eq( "result_3" )
		end

	end

end

