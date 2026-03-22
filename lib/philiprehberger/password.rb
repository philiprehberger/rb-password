# frozen_string_literal: true

require_relative 'password/version'
require_relative 'password/strength'
require_relative 'password/policy'
require_relative 'password/generator'

module Philiprehberger
  module Password
    def self.strength(password)
      Strength.compute(password)
    end

    def self.generate(**options)
      Generator.generate(**options)
    end
  end
end
