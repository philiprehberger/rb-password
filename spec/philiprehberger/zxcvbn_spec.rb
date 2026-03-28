# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Password::Zxcvbn do
  describe '.estimate' do
    it 'returns a hash with required keys' do
      result = described_class.estimate('password')
      expect(result).to have_key(:score)
      expect(result).to have_key(:patterns)
      expect(result).to have_key(:crack_time_display)
    end

    it 'returns score 0 for empty password' do
      result = described_class.estimate('')
      expect(result[:score]).to eq(0)
      expect(result[:patterns]).to be_empty
      expect(result[:crack_time_display]).to eq('instant')
    end

    it 'returns low score for common passwords' do
      result = described_class.estimate('password')
      expect(result[:score]).to be <= 1
    end

    it 'returns low score for "123456"' do
      result = described_class.estimate('123456')
      expect(result[:score]).to eq(0)
    end

    it 'returns high score for complex random passwords' do
      result = described_class.estimate('X9#kZ!mQ7@wR4bN5&jP2cL8')
      expect(result[:score]).to be >= 3
    end

    context 'dictionary word detection' do
      it 'detects common password in dictionary' do
        result = described_class.estimate('password')
        dict_patterns = result[:patterns].select { |p| p[:type] == :dictionary }
        expect(dict_patterns).not_to be_empty
      end

      it 'detects common words embedded in password' do
        result = described_class.estimate('mydragonpass')
        dict_patterns = result[:patterns].select { |p| p[:type] == :dictionary && p[:dictionary] == :common_word }
        expect(dict_patterns).not_to be_empty
        expect(dict_patterns.first[:word]).to eq('dragon')
      end
    end

    context 'l33t substitution detection' do
      it 'detects l33t substituted common words' do
        result = described_class.estimate('p@$$w0rd')
        leet_patterns = result[:patterns].select { |p| p[:type] == :leet }
        expect(leet_patterns).not_to be_empty
      end

      it 'detects l33t version of dragon -> dr@g0n' do
        result = described_class.estimate('dr@g0n')
        leet_patterns = result[:patterns].select { |p| p[:type] == :leet }
        expect(leet_patterns).not_to be_empty
      end

      it 'does not false-positive on non-leet passwords' do
        result = described_class.estimate('xKzMqWrBnJ')
        leet_patterns = result[:patterns].select { |p| p[:type] == :leet }
        expect(leet_patterns).to be_empty
      end
    end

    context 'spatial pattern detection' do
      it 'detects qwerty keyboard patterns' do
        result = described_class.estimate('qwertypass1')
        spatial = result[:patterns].select { |p| p[:type] == :spatial }
        expect(spatial).not_to be_empty
      end

      it 'detects asdf keyboard pattern' do
        result = described_class.estimate('myasdfghpass')
        spatial = result[:patterns].select { |p| p[:type] == :spatial }
        expect(spatial).not_to be_empty
      end
    end

    context 'date pattern detection' do
      it 'detects year patterns' do
        result = described_class.estimate('mypass!2024!')
        date_patterns = result[:patterns].select { |p| p[:type] == :date }
        expect(date_patterns).not_to be_empty
      end

      it 'detects date formats with separators' do
        result = described_class.estimate('pass12/25/2024!')
        date_patterns = result[:patterns].select { |p| p[:type] == :date }
        expect(date_patterns).not_to be_empty
      end
    end

    context 'keyboard pattern detection' do
      it 'detects repeated characters' do
        result = described_class.estimate('aaaaapass1')
        repeated = result[:patterns].select { |p| p[:type] == :repeated }
        expect(repeated).not_to be_empty
      end

      it 'detects sequential patterns' do
        result = described_class.estimate('abcdefgh1!')
        sequence = result[:patterns].select { |p| p[:type] == :sequence }
        expect(sequence).not_to be_empty
      end
    end

    context 'crack time display' do
      it 'returns "instant" for score 0' do
        result = described_class.estimate('123456')
        expect(result[:crack_time_display]).to eq('instant')
      end

      it 'returns a time description for each score level' do
        expect(described_class::CRACK_TIMES[0]).to eq('instant')
        expect(described_class::CRACK_TIMES[1]).to eq('minutes')
        expect(described_class::CRACK_TIMES[2]).to eq('hours to days')
        expect(described_class::CRACK_TIMES[3]).to eq('months to years')
        expect(described_class::CRACK_TIMES[4]).to eq('centuries')
      end
    end

    context 'scoring logic' do
      it 'penalizes passwords with many detected patterns' do
        simple = described_class.estimate('passworddragon')
        complex = described_class.estimate('xK9#mZ2!pQ7@wR4b')
        expect(simple[:score]).to be < complex[:score]
      end

      it 'gives score 0 to very short passwords' do
        result = described_class.estimate('abc')
        expect(result[:score]).to eq(0)
      end
    end
  end
end
