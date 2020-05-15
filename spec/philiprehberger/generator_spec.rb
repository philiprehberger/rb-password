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
