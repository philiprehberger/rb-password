# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Password::Generator do
  describe '.generate' do
    it 'generates password of default length' do
      password = described_class.generate
      expect(password.length).to eq(16)
    end

    it 'generates password of specified length' do
      password = described_class.generate(length: 32)
      expect(password.length).to eq(32)
    end

    it 'generates unique passwords' do
      passwords = Array.new(5) { described_class.generate }
      expect(passwords.uniq.length).to eq(5)
    end

    it 'includes all character classes by default' do
      password = described_class.generate(length: 50)
      expect(password).to match(/[a-z]/)
      expect(password).to match(/[A-Z]/)
      expect(password).to match(/\d/)
    end

    it 'generates letters only when symbols and digits disabled' do
      password = described_class.generate(length: 20, digits: false, symbols: false)
      expect(password).to match(/\A[a-zA-Z]+\z/)
    end

    it 'generates digits only with pin style' do
      password = described_class.generate(length: 6, style: :pin)
      expect(password).to match(/\A\d+\z/)
      expect(password.length).to eq(6)
    end

    it 'generates passphrase with style option' do
      phrase = described_class.generate(style: :passphrase)
      words = phrase.split('-')
      expect(words.length).to eq(4)
      expect(words).to all(match(/\A[a-z]+\z/))
    end

    it 'supports custom word count for passphrase' do
      phrase = described_class.generate(style: :passphrase, words: 6)
      expect(phrase.split('-').length).to eq(6)
    end

    it 'supports custom separator for passphrase' do
      phrase = described_class.generate(style: :passphrase, separator: '_')
      expect(phrase).to include('_')
      expect(phrase).not_to include('-')
    end

    context 'with exclude_ambiguous' do
      it 'omits visually ambiguous characters' do
        password = described_class.generate(length: 200, exclude_ambiguous: true)
        described_class::AMBIGUOUS.each do |ch|
          expect(password).not_to include(ch)
        end
      end

      it 'still guarantees each requested character class' do
        password = described_class.generate(length: 60, exclude_ambiguous: true)
        expect(password).to match(/[a-z]/)
        expect(password).to match(/[A-Z]/)
        expect(password).to match(/\d/)
      end
    end

    context 'with a custom symbol set' do
      it 'only uses symbols from the provided array' do
        password = described_class.generate(length: 60, uppercase: false, lowercase: false, digits: false,
                                            symbols: %w[# $ %])
        expect(password).to match(/\A[#$%]+\z/)
      end

      it 'only uses symbols from the provided symbol_set string' do
        password = described_class.generate(length: 60, uppercase: false, lowercase: false, digits: false,
                                            symbol_set: '#$%')
        expect(password).to match(/\A[#$%]+\z/)
      end
    end

    context 'with style: :pronounceable' do
      it 'respects the requested length' do
        expect(described_class.generate(style: :pronounceable, length: 14).length).to eq(14)
      end

      it 'alternates consonants and vowels when digits and symbols are disabled' do
        password = described_class.generate(style: :pronounceable, length: 10, digits: false, symbols: false)
        password.chars.each_with_index do |ch, i|
          expect(ch).to match(/[a-z]/)
          if i.even?
            expect(described_class::VOWELS).not_to include(ch)
          else
            expect(described_class::VOWELS).to include(ch)
          end
        end
      end

      it 'uses SecureRandom' do
        expect(SecureRandom).to receive(:random_number).at_least(:once).and_call_original
        described_class.generate(style: :pronounceable, length: 12)
      end
    end
  end

  describe 'WORD_LIST' do
    it 'contains 100+ words' do
      expect(described_class::WORD_LIST.length).to be > 100
    end

    it 'contains only lowercase words' do
      described_class::WORD_LIST.each do |word|
        expect(word).to match(/\A[a-z]+\z/), "Expected '#{word}' to be lowercase letters only"
      end
    end

    it 'is frozen' do
      expect(described_class::WORD_LIST).to be_frozen
    end

    it 'has no duplicates' do
      expect(described_class::WORD_LIST.length).to eq(described_class::WORD_LIST.uniq.length)
    end
  end
end
