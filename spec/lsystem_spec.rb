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

end

