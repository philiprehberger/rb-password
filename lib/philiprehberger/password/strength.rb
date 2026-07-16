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

      # Length below which the feedback advises adding characters.
      MIN_RECOMMENDED_LENGTH = 12

      def self.compute(password)
        pwd = password.to_s
        return { score: 0, label: :terrible, entropy: 0.0, feedback: feedback(pwd, 0) } if pwd.empty?

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

        { score: s, label: LABELS[s], entropy: ent.round(2), feedback: feedback(pwd, s) }
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

      # Build an actionable list of suggestions for improving a password.
      # Returns an empty array for passwords that already score "strong" (3)
      # or "excellent" (4).
      def self.feedback(password, score)
        return [] if score >= 3

        pwd = password.to_s
        tips = []

        tips << 'Avoid using a common password' if CommonPasswords.include?(pwd.downcase)
        tips << "Use at least #{MIN_RECOMMENDED_LENGTH} characters" if pwd.length < MIN_RECOMMENDED_LENGTH

        missing = missing_classes(pwd)
        tips << "Add #{to_sentence(missing)}" unless missing.empty?
        tips.concat(pattern_tips(pwd))

        tips.uniq
      end

      def self.missing_classes(password)
        missing = []
        missing << 'lowercase letters' unless password.match?(/[a-z]/)
        missing << 'uppercase letters' unless password.match?(/[A-Z]/)
        missing << 'digits' unless password.match?(/\d/)
        missing << 'symbols' unless password.match?(/[^a-zA-Z\d]/)
        missing
      end

      def self.pattern_tips(password)
        Patterns.detect(password).filter_map do |pattern|
          case pattern[:type]
          when :sequence
            "Avoid the sequence '#{pattern[:token]}'"
          when :keyboard_row
            "Avoid keyboard patterns like '#{pattern[:token]}'"
          when :repeated
            "Avoid repeated characters like '#{pattern[:token]}'"
          end
        end
      end

      def self.to_sentence(items)
        case items.length
        when 0 then ''
        when 1 then items.first
        when 2 then "#{items.first} and #{items.last}"
        else "#{items[0..-2].join(', ')}, and #{items.last}"
        end
      end

      private_class_method :missing_classes, :pattern_tips, :to_sentence
    end
  end
end
