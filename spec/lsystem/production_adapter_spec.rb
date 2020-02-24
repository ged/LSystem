#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'lsystem/production_adapter'


RSpec.describe LSysteem::ProductionAdapter do


	describe "subclasses" do

		let( :subclass ) do
			Class.new( described_class ) do

				def initialize
					@calls = []
				end

				attr_reader :calls

				def do_a_thing ; self.calls << __method__ ; end
				def do_b_thing ; self.calls << __method__ ; end

			end
		end


		it "can declare a method map for its productions" do
			subclass.production_map 'A' => :print_a

			
		end

	end

end

