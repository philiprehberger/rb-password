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

    it 'supports alpha charset' do
      password = described_class.generate(length: 20, charset: :alpha)
      expect(password).to match(/\A[a-zA-Z]+\z/)
    end

    it 'supports alphanumeric charset' do
      password = described_class.generate(length: 20, charset: :alphanumeric)
      expect(password).to match(/\A[a-zA-Z0-9]+\z/)
    end

    it 'supports digits charset' do
      password = described_class.generate(length: 10, charset: :digits)
      expect(password).to match(/\A\d+\z/)
    end
  end

  describe '.passphrase' do
    it 'generates passphrase with default settings' do
      phrase = described_class.passphrase
      words = phrase.split('-')
      expect(words.length).to eq(4)
      expect(words).to all(match(/\A[a-z]+\z/))
    end

    it 'supports custom word count' do
      phrase = described_class.passphrase(words: 6)
      expect(phrase.split('-').length).to eq(6)
    end

    it 'supports custom separator' do
      phrase = described_class.passphrase(separator: '_')
      expect(phrase).to include('_')
      expect(phrase).not_to include('-')
    end
  end
end
