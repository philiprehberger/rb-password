# frozen_string_literal: true

module Philiprehberger
  module Password
    module Zxcvbn
      # L33t substitution mappings
      LEET_MAP = {
        '@' => 'a', '4' => 'a', '^' => 'a',
        '8' => 'b',
        '(' => 'c', '{' => 'c', '<' => 'c',
        '3' => 'e',
        '6' => 'g', '9' => 'g',
        '#' => 'h',
        '1' => 'i', '!' => 'i', '|' => 'i',
        '7' => 'l',
        '0' => 'o',
        '$' => 's', '5' => 's',
        '+' => 't',
        '2' => 'z'
      }.freeze

      # Common date patterns
      DATE_PATTERNS = [
        /\b(19|20)\d{2}\b/, # yyyy
        %r{\b(0?[1-9]|1[0-2])[/-](0?[1-9]|[12]\d|3[01])[/-](\d{2}|\d{4})\b}, # mm/dd/yy or mm/dd/yyyy
        %r{\b(0?[1-9]|[12]\d|3[01])[/-](0?[1-9]|1[0-2])[/-](\d{2}|\d{4})\b}, # dd/mm/yy or dd/mm/yyyy
        /\b(0?[1-9]|1[0-2])(0?[1-9]|[12]\d|3[01])(\d{2}|\d{4})\b/,             # mmddyy or mmddyyyy
        /\b(\d{2}|\d{4})(0?[1-9]|1[0-2])(0?[1-9]|[12]\d|3[01])\b/              # yymmdd or yyyymmdd
      ].freeze

      SPATIAL_PATTERNS_QWERTY = %w[
        qwert werty ertyu rtyui tyuio yuiop
        asdfg sdfgh dfghj fghjk ghjkl
        zxcvb xcvbn cvbnm
        qwer wert erty rtyu tyui yuio uiop
        asdf sdfg dfgh fghj ghjk hjkl
        zxcv xcvb cvbn vbnm
      ].freeze

      CRACK_TIMES = {
        0 => 'instant',
        1 => 'minutes',
        2 => 'hours to days',
        3 => 'months to years',
        4 => 'centuries'
      }.freeze

      # Perform zxcvbn-style password strength estimation.
      # Returns a hash with :score (0-4), :patterns (array), and :crack_time_display.
      def self.estimate(password)
        pwd = password.to_s
        return { score: 0, patterns: [], crack_time_display: 'instant' } if pwd.empty?

        patterns = []
        patterns.concat(detect_dictionary_words(pwd))
        patterns.concat(detect_leet_substitutions(pwd))
        patterns.concat(detect_spatial_patterns(pwd))
        patterns.concat(detect_date_patterns(pwd))
        patterns.concat(detect_keyboard_patterns(pwd))

        # Calculate base entropy
        base_entropy = Strength.entropy(pwd)

        # Apply penalty for detected patterns
        penalty = patterns.sum { |p| pattern_penalty(p) }
        adjusted_entropy = [base_entropy - penalty, 0.0].max

        score = entropy_to_score(adjusted_entropy, pwd.length, patterns.length)

        {
          score: score,
          patterns: patterns,
          crack_time_display: CRACK_TIMES[score]
        }
      end

      # Detect dictionary words in the password
      def self.detect_dictionary_words(password)
        pwd_lower = password.downcase
        results = []

        # Check against common passwords list
        if CommonPasswords.include?(pwd_lower)
          results << { type: :dictionary, token: password, dictionary: :common_passwords }
        end

        # Check for common English words (4+ chars) embedded in the password
        common_words = %w[
          password dragon master monkey shadow sunshine princess football baseball
          soccer hockey access admin hello welcome flower charlie trigger hunter
          killer summer winter spring autumn secret garden nature angel
          love baby trust heart friend family
          super power magic ninja warrior wizard
          happy lucky golden silver diamond
        ].freeze

        common_words.each do |word|
          idx = pwd_lower.index(word)
          next unless idx

          results << {
            type: :dictionary,
            token: password[idx, word.length],
            dictionary: :common_word,
            word: word,
            start: idx
          }
        end

        results
      end

      # Detect l33t speak substitutions
      def self.detect_leet_substitutions(password)
        desubbed = password.chars.map { |c| LEET_MAP[c] || c }.join.downcase
        return [] if desubbed == password.downcase

        results = []
        has_subs = password.chars.any? { |c| LEET_MAP.key?(c) }
        return results unless has_subs

        # Check if the desubstituted version contains dictionary words
        common_words = %w[
          password dragon master monkey shadow sunshine princess football baseball
          soccer hockey access admin hello welcome love secret trust angel
          super power magic killer summer winter spring
        ].freeze

        common_words.each do |word|
          idx = desubbed.index(word)
          next unless idx

          original_token = password[idx, word.length]
          next if original_token.downcase == word # Already caught by dictionary detection

          results << {
            type: :leet,
            token: original_token,
            desubstituted: word,
            start: idx
          }
        end

        # Also check the full password as a leet variant
        if CommonPasswords.include?(desubbed)
          results << { type: :leet, token: password, desubstituted: desubbed }
        end

        results
      end

      # Detect spatial keyboard patterns
      def self.detect_spatial_patterns(password)
        pwd_lower = password.downcase
        results = []

        SPATIAL_PATTERNS_QWERTY.each do |pattern|
          idx = 0
          while (found = pwd_lower.index(pattern, idx))
            results << {
              type: :spatial,
              token: password[found, pattern.length],
              start: found,
              keyboard: :qwerty
            }
            idx = found + 1
          end
        end

        # Deduplicate overlapping spatial patterns, keep longest
        sorted = results.sort_by { |p| [-p[:token].length, p[:start]] }
        kept = []
        sorted.each do |pat|
          pat_end = pat[:start] + pat[:token].length
          overlap = kept.any? do |k|
            k_end = k[:start] + k[:token].length
            pat[:start] < k_end && pat_end > k[:start]
          end
          kept << pat unless overlap
        end

        kept.sort_by { |p| p[:start] }
      end

      # Detect date patterns
      def self.detect_date_patterns(password)
        results = []

        DATE_PATTERNS.each do |pattern|
          password.scan(pattern) do
            match = Regexp.last_match
            results << {
              type: :date,
              token: match[0],
              start: match.begin(0)
            }
          end
        end

        results.uniq { |p| [p[:token], p[:start]] }
      end

      # Detect keyboard sequence patterns using the Patterns module
      def self.detect_keyboard_patterns(password)
        Patterns.detect(password).map do |p|
          {
            type: p[:type] == :keyboard_row ? :spatial : p[:type],
            token: p[:token],
            start: p[:start]
          }
        end
      end

      # Calculate penalty for a detected pattern
      def self.pattern_penalty(pattern)
        case pattern[:type]
        when :dictionary
          pattern[:dictionary] == :common_passwords ? 20.0 : 10.0
        when :leet
          8.0
        when :spatial, :keyboard_row
          6.0
        when :date
          5.0
        when :sequence
          7.0
        when :repeated
          8.0
        else
          3.0
        end
      end

      # Convert adjusted entropy + context into a 0-4 score
      def self.entropy_to_score(entropy, length, pattern_count)
        # Short passwords with patterns are weak regardless of entropy
        if length < 6
          return 0
        end

        if pattern_count > 3
          return [1, (entropy / 30.0).floor].min
        end

        if entropy < 20
          0
        elsif entropy < 35
          1
        elsif entropy < 55
          2
        elsif entropy < 75
          3
        else
          4
        end
      end

      private_class_method :detect_dictionary_words, :detect_leet_substitutions,
                           :detect_spatial_patterns, :detect_date_patterns,
                           :detect_keyboard_patterns, :pattern_penalty, :entropy_to_score
    end
  end
end
