# frozen_string_literal: true

module Philiprehberger
  module Password
    module Patterns
      QWERTY_ROWS = %w[
        qwertyuiop
        asdfghjkl
        zxcvbnm
        1234567890
      ].freeze

      QWERTY_ROWS_SHIFTED = %w[
        !@#$%^&*()
      ].freeze

      ALPHABETIC = ('a'..'z').to_a.join.freeze
      NUMERIC = ('0'..'9').to_a.join.freeze

      MIN_SEQUENCE_LENGTH = 3
      MIN_REPEAT_LENGTH = 3

      # Detect keyboard patterns, sequences, and repeated characters in a password.
      # Returns an array of hashes describing each detected pattern.
      def self.detect(password)
        pwd = password.to_s
        return [] if pwd.empty?

        patterns = []
        patterns.concat(detect_keyboard_rows(pwd))
        patterns.concat(detect_sequences(pwd))
        patterns.concat(detect_repeated_chars(pwd))
        patterns
      end

      # Detect runs along QWERTY keyboard rows (forward and reverse)
      def self.detect_keyboard_rows(password)
        pwd = password.downcase
        results = []

        (QWERTY_ROWS + QWERTY_ROWS_SHIFTED).each do |row|
          [row, row.reverse].each do |sequence|
            (0..(pwd.length - MIN_SEQUENCE_LENGTH)).each do |i|
              len = MIN_SEQUENCE_LENGTH
              while i + len <= pwd.length
                substr = pwd[i, len]
                break unless sequence.include?(substr)

                len += 1

              end
              match_len = len - 1
              next unless match_len >= MIN_SEQUENCE_LENGTH

              pwd[i, match_len]
              already_covered = results.any? do |r|
                r[:type] == :keyboard_row && r[:start] <= i && (r[:start] + r[:token].length) >= (i + match_len)
              end
              next if already_covered

              results << {
                type: :keyboard_row,
                token: password[i, match_len],
                start: i,
                length: match_len,
                direction: sequence == row ? :forward : :reverse
              }
            end
          end
        end

        # Keep only the longest non-overlapping matches
        deduplicate(results)
      end

      # Detect alphabetic and numeric sequences (abc, 123, etc.)
      def self.detect_sequences(password)
        pwd = password.downcase
        results = []

        [ALPHABETIC, ALPHABETIC.reverse, NUMERIC, NUMERIC.reverse].each do |seq|
          direction = [ALPHABETIC, NUMERIC].include?(seq) ? :ascending : :descending
          seq_type = seq.include?('a') ? :alphabetic : :numeric

          (0..(pwd.length - MIN_SEQUENCE_LENGTH)).each do |i|
            len = MIN_SEQUENCE_LENGTH
            while i + len <= pwd.length
              substr = pwd[i, len]
              break unless seq.include?(substr)

              len += 1

            end
            match_len = len - 1
            next unless match_len >= MIN_SEQUENCE_LENGTH

            matched = password[i, match_len]
            already_covered = results.any? do |r|
              r[:type] == :sequence && r[:start] <= i && (r[:start] + r[:token].length) >= (i + match_len)
            end
            next if already_covered

            results << {
              type: :sequence,
              token: matched,
              start: i,
              length: match_len,
              sequence_type: seq_type,
              direction: direction
            }
          end
        end

        deduplicate(results)
      end

      # Detect repeated characters (aaa, 111, etc.)
      def self.detect_repeated_chars(password)
        results = []
        i = 0
        while i < password.length
          char = password[i]
          run_length = 1
          run_length += 1 while i + run_length < password.length && password[i + run_length] == char

          if run_length >= MIN_REPEAT_LENGTH
            results << {
              type: :repeated,
              token: password[i, run_length],
              start: i,
              length: run_length,
              repeated_char: char
            }
          end
          i += [run_length, 1].max
        end
        results
      end

      # Remove overlapping patterns, keeping longest matches
      def self.deduplicate(patterns)
        sorted = patterns.sort_by { |p| [-p[:length], p[:start]] }
        kept = []
        sorted.each do |pat|
          overlap = kept.any? do |k|
            pat_end = pat[:start] + pat[:length]
            k_end = k[:start] + k[:length]
            pat[:start] < k_end && pat_end > k[:start]
          end
          kept << pat unless overlap
        end
        kept.sort_by { |p| p[:start] }
      end

      private_class_method :detect_keyboard_rows, :detect_sequences, :detect_repeated_chars, :deduplicate
    end
  end
end
