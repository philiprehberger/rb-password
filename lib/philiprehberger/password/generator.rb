# frozen_string_literal: true

require 'securerandom'

module Philiprehberger
  module Password
    module Generator
      LOWERCASE = ('a'..'z').to_a.freeze
      UPPERCASE = ('A'..'Z').to_a.freeze
      DIGITS = ('0'..'9').to_a.freeze
      SYMBOLS = %w[! @ # $ % ^ & * - _ + = . ? ~].freeze

      WORD_LIST = %w[
        abandon ability able about above absent absorb abstract absurd abuse access
        account accuse achieve acid across action actor actual adapt adjust admit
        adult advance advice afford afraid again agent agree ahead aim air airport
        alarm album alert alien allow almost alone alpha already also alter always
        amateur amazing among amount amuse anchor ancient anger angle angry animal
        ankle announce annual another answer antenna antique anxiety apart apology
        appear apple approve arch arena argue armor army around arrange arrest arrive
        arrow art artist artwork ask aspect assault asset assist assume athlete atom
        attack attend auction audit august aunt author autumn average avocado avoid
        awake aware awesome awful awkward axis baby bachelor bacon badge bag balance
        balcony ball bamboo banana banner bar bargain barrel base basket battle beach
        bean beauty because become beef before begin behave behind believe below bench
        benefit best betray better between beyond bicycle bind biology bird birth
        bitter black blade blame blanket blast bleak bless blind blood blossom blue
        blur board boat body boil bomb bone bonus book border boring borrow boss
        bottom bounce box brain brand brave bread breeze brick bridge bright bring
        broken brother brown brush bubble buddy budget buffalo build bullet bundle
        burger burst bus business busy butter buyer cabin cable cactus cage cake call
        calm camera camp canal cancel cannon canvas canyon capital captain carbon card
        cargo carpet carry cart case castle casual catch cause caution cave ceiling
        celery cement census cereal certain chair chalk champion change chaos chapter
        charge chase check cheese cherry chest chicken chief child choice choose chunk
        circle citizen city civil claim clap clarify claw clay clean clerk clever
        click client cliff climb clinic clip clock close cloud clown cluster coach
        coconut code coffee coil collect color column combine comfort comic common
        company concert confirm congress connect consider control convince cool copper
        coral core correct cost cotton country couple course cousin cover craft crane
      ].freeze

      def self.generate(length: 16, uppercase: true, lowercase: true, digits: true, symbols: true, style: nil,
                        words: 4, separator: '-')
        case style
        when :passphrase
          generate_passphrase(words: words, separator: separator)
        when :pin
          generate_pin(length: length)
        else
          generate_random(length: length, uppercase: uppercase, lowercase: lowercase,
                          digits: digits, symbols: symbols)
        end
      end

      def self.generate_random(length:, uppercase:, lowercase:, digits:, symbols:)
        chars = []
        required = []

        if lowercase
          chars.concat(LOWERCASE)
          required << LOWERCASE
        end
        if uppercase
          chars.concat(UPPERCASE)
          required << UPPERCASE
        end
        if digits
          chars.concat(DIGITS)
          required << DIGITS
        end
        if symbols
          chars.concat(SYMBOLS)
          required << SYMBOLS
        end

        return '' if chars.empty? || length <= 0

        result = Array.new(length) { chars[SecureRandom.random_number(chars.length)] }

        # Guarantee at least one from each required class
        required.each_with_index do |char_class, i|
          break if i >= length

          result[i] = char_class[SecureRandom.random_number(char_class.length)]
        end

        result.shuffle!(random: SecureRandom)
        result.join
      end

      def self.generate_passphrase(words:, separator:)
        Array.new(words) { WORD_LIST[SecureRandom.random_number(WORD_LIST.length)] }.join(separator)
      end

      def self.generate_pin(length:)
        Array.new(length) { SecureRandom.random_number(10).to_s }.join
      end

      private_class_method :generate_random, :generate_passphrase, :generate_pin
    end
  end
end
