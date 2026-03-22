# frozen_string_literal: true

RSpec.describe Philiprehberger::Password do
  describe '.strength' do
    it 'returns terrible for empty password' do
      result = described_class.strength('')
      expect(result[:score]).to eq(0)
      expect(result[:label]).to eq(:terrible)
    end

    it 'returns weak for simple password' do
      result = described_class.strength('abc')
      expect(result[:score]).to be <= 1
    end

    it 'returns strong for complex password' do
      result = described_class.strength('C0mpl3x!P@ssw0rd#2026')
      expect(result[:score]).to be >= 3
    end

    it 'includes entropy value' do
      result = described_class.strength('test')
      expect(result[:entropy]).to be_a(Float)
      expect(result[:entropy]).to be > 0
    end
  end

  describe '.entropy' do
    it 'returns 0 for empty string' do
      expect(described_class.entropy('')).to eq(0.0)
    end

    it 'increases with password length' do
      short = described_class.entropy('abc')
      long = described_class.entropy('abcdefghij')
      expect(long).to be > short
    end

    it 'increases with character diversity' do
      lower = described_class.entropy('abcdefgh')
      mixed = described_class.entropy('aBcDeFgH')
      expect(mixed).to be > lower
    end
  end

  describe '.validate' do
    it 'passes for valid password with default policy' do
      result = described_class.validate('MyStr0ng!Pass')
      expect(result.valid?).to be true
    end

    it 'fails for short password' do
      result = described_class.validate('short')
      expect(result.valid?).to be false
      expect(result.errors).to include(a_string_matching(/at least/))
    end

    it 'fails for common password' do
      result = described_class.validate('password')
      expect(result.valid?).to be false
      expect(result.errors).to include('Password is too common')
    end

    it 'enforces uppercase requirement' do
      result = described_class.validate('lowercase123!', require_uppercase: true)
      expect(result.valid?).to be false
      expect(result.errors).to include(a_string_matching(/uppercase/))
    end

    it 'enforces digit requirement' do
      result = described_class.validate('NoDigitsHere!', require_digit: true)
      expect(result.valid?).to be false
      expect(result.errors).to include(a_string_matching(/digit/))
    end

    it 'enforces symbol requirement' do
      result = described_class.validate('NoSymbols123', require_symbol: true)
      expect(result.valid?).to be false
      expect(result.errors).to include(a_string_matching(/special/))
    end
  end

  describe '.generate' do
    it 'generates password of specified length' do
      password = described_class.generate(length: 20)
      expect(password.length).to eq(20)
    end

    it 'generates unique passwords' do
      passwords = Array.new(10) { described_class.generate }
      expect(passwords.uniq.length).to eq(10)
    end

    it 'includes all character classes by default' do
      password = described_class.generate(length: 32)
      expect(password).to match(/[a-z]/)
      expect(password).to match(/[A-Z]/)
      expect(password).to match(/\d/)
    end
  end

  describe '.passphrase' do
    it 'generates passphrase with default word count' do
      phrase = described_class.passphrase
      words = phrase.split('-')
      expect(words.length).to eq(4)
    end

    it 'respects custom word count' do
      phrase = described_class.passphrase(words: 6)
      words = phrase.split('-')
      expect(words.length).to eq(6)
    end

    it 'supports custom separator' do
      phrase = described_class.passphrase(separator: '.')
      expect(phrase).to include('.')
    end
  end

  describe '.breached?' do
    it 'returns true for common passwords' do
      expect(described_class.breached?('password')).to be true
      expect(described_class.breached?('123456')).to be true
    end

    it 'returns false for unique passwords' do
      expect(described_class.breached?('xK9#mZ2!pQ7@wR4')).to be false
    end

    it 'is case insensitive' do
      expect(described_class.breached?('PASSWORD')).to be true
    end

    it 'returns false for nil or empty' do
      expect(described_class.breached?(nil)).to be false
      expect(described_class.breached?('')).to be false
    end
  end
end
