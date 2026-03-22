# frozen_string_literal: true

require 'securerandom'

module Philiprehberger
  module Password
    module Generator
      LOWERCASE = ('a'..'z').to_a.freeze
      UPPERCASE = ('A'..'Z').to_a.freeze
      DIGITS = ('0'..'9').to_a.freeze
      SYMBOLS = %w[! @ # $ % ^ & * - _ + = . ?].freeze
      ALL = (LOWERCASE + UPPERCASE + DIGITS + SYMBOLS).freeze

      WORD_LIST = %w[
        abandon ability able about above absent absorb abstract absurd abuse access
        accident account accuse achieve acid across action actor actress actual adapt
        adjust admit adult advance advice afford afraid again agent agree ahead aim
        air airport aisle alarm album alert alien allow almost alone alpha already
        also alter always amateur amazing among amount amused analyst anchor ancient
        anger angle angry animal ankle announce annual another answer antenna antique
        anxiety any apart apology appear apple approve arch arena argue armor army
        around arrange arrest arrive arrow art artefact artist artwork ask aspect
        assault asset assist assume asthma athlete atom attack attend attitude attract
        auction audit august aunt author auto autumn average avocado avoid awake aware
        awesome awful awkward axis baby bachelor bacon badge bag balance balcony ball
        bamboo banana banner bar barely bargain barrel base basic basket battle beach
        bean beauty because become beef before begin behave behind believe below bench
        benefit best betray better between beyond bicycle bid bike bind biology bird
        birth bitter black blade blame blanket blast bleak bless blind blood blossom
        blue blur blush board boat body boil bomb bone bonus book boost border boring
        borrow boss bottom bounce box boy bracket brain brand brave bread breeze brick
        bridge brief bright bring brisk broken bronze broom brother brown brush bubble
        buddy budget buffalo build bullet bundle burden burger burst bus business busy
        butter buyer buzz cabbage cabin cable cactus cage cake call calm camera camp
        canal cancel candy cannon canoe canvas canyon capable capital captain carbon
        card cargo carpet carry cart case cash casino castle casual catalog catch cause
        caution cave ceiling celery cement census cereal certain chair chalk champion
        change chaos chapter charge chase cheap check cheese cherry chest chicken chief
        child chimney choice choose chronic chunk chuckle churn cigarette cinnamon circle
        citizen city civil claim clap clarify claw clay clean clerk clever click client
        cliff climb clinic clip clock close cloth cloud clown club clump cluster clutch
        coach coast coconut code coffee coil coin collect color column combine come
        comfort comic common company concert conduct confirm congress connect consider
        control convince cook cool copper copy coral core corn correct cost cotton couch
        country couple course cousin cover coyote crack cradle craft crash crater crawl
        crazy cream credit creek crew cricket crime crisp critic crop cross crouch crowd
        crucial cruel cruise crumble crush cry crystal cube culture cup cupboard curious
        current curtain curve cushion custom cute cycle dad damage damp dance danger
        daring dash daughter dawn day deal debate debris decade december decide decline
        decorate decrease deer defense define defy degree delay deliver demand demise
        denial dentist deny depart depend deposit depth deputy derive describe desert
      ].freeze

      def self.generate(length: 16, charset: :all)
        chars = case charset
                when :all then ALL
                when :alpha then LOWERCASE + UPPERCASE
                when :alphanumeric then LOWERCASE + UPPERCASE + DIGITS
                when :digits then DIGITS
                when Array then charset
                else ALL
                end

        result = Array.new(length) { chars[SecureRandom.random_number(chars.length)] }

        if charset == :all && length >= 4
          result[0] = LOWERCASE[SecureRandom.random_number(LOWERCASE.length)]
          result[1] = UPPERCASE[SecureRandom.random_number(UPPERCASE.length)]
          result[2] = DIGITS[SecureRandom.random_number(DIGITS.length)]
          result[3] = SYMBOLS[SecureRandom.random_number(SYMBOLS.length)]
          result.shuffle!(random: SecureRandom)
        end

        result.join
      end

      def self.passphrase(words: 4, separator: '-')
        Array.new(words) { WORD_LIST[SecureRandom.random_number(WORD_LIST.length)] }.join(separator)
      end
    end
  end
end
