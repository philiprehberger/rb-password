# frozen_string_literal: true

module Philiprehberger
  module Password
    module Strength
      LABELS = {
        0 => :terrible,
        1 => :weak,
        2 => :fair,
        3 => :strong,
        4 => :excellent
      }.freeze

      def self.compute(password)
        pwd = password.to_s
        return { score: 0, label: :terrible, entropy: 0.0 } if pwd.empty?

        ent = entropy(pwd)

        s = if ent < 28
              0
            elsif ent < 36
              1
            elsif ent < 60
              2
            elsif ent < 80
              3
            else
              4
            end

        { score: s, label: LABELS[s], entropy: ent.round(2) }
      end

      def self.entropy(password)
        pwd = password.to_s
        return 0.0 if pwd.empty?

        pool = 0
        pool += 26 if pwd.match?(/[a-z]/)
        pool += 26 if pwd.match?(/[A-Z]/)
        pool += 10 if pwd.match?(/\d/)
        pool += 33 if pwd.match?(/[^a-zA-Z\d]/)

        pwd.length * Math.log2([pool, 1].max)
      end
    end
  end
end
