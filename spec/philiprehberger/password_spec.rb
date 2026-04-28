# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Password do
  it 'has a version number' do
    expect(Philiprehberger::Password::VERSION).not_to be_nil
  end

  it 'has a version number' do
    expect(Philiprehberger::Password::VERSION).not_to be_nil
  end

  describe Philiprehberger::Password::Policy do
    describe '#validate' do
      it 'fails for min_length violation' do
        policy = described_class.new(min_length: 12)
        result = policy.validate('short')
        expect(result.valid?).to be false
        expect(result.errors).to include(a_string_matching(/at least 12/))
      end

      it 'fails for require_uppercase violation' do
        policy = described_class.new(require_uppercase: true)
        result = policy.validate('alllowercase1')
        expect(result.valid?).to be false
        expect(result.errors).to include(a_string_matching(/uppercase/))
      end

      it 'fails for require_digit violation' do
        policy = described_class.new(require_digit: true)
        result = policy.validate('NoDigitsHere!')
        expect(result.valid?).to be false
        expect(result.errors).to include(a_string_matching(/digit/))
      end

      it 'fails for require_symbol violation' do
        policy = described_class.new(require_symbol: true)
        result = policy.validate('NoSymbols123')
        expect(result.valid?).to be false
        expect(result.errors).to include(a_string_matching(/symbol/))
      end

      it 'passes for valid password meeting all requirements' do
        policy = described_class.new(
          min_length: 8,
          require_uppercase: true,
          require_lowercase: true,
          require_digit: true,
          require_symbol: true
        )
        result = policy.validate('MyStr0ng!Pass')
        expect(result.valid?).to be true
        expect(result.errors).to be_empty
      end

      it 'rejects common password "password" when reject_common is true' do
        policy = described_class.new(reject_common: true)
        result = policy.validate('password')
        expect(result.valid?).to be false
        expect(result.errors).to include(a_string_matching(/common/))
      end

      it 'rejects common password "123456" when reject_common is true' do
        policy = described_class.new(reject_common: true)
        result = policy.validate('123456')
        expect(result.valid?).to be false
        expect(result.errors).to include(a_string_matching(/common/))
      end

      it 'includes a score in the result' do
        policy = described_class.new
        result = policy.validate('C0mpl3x!P@ss')
        expect(result.score).to be_a(Integer)
        expect(result.score).to be_between(0, 4)
      end
    end
  end

  describe '.common?' do
    it 'returns true for known common passwords' do
      expect(described_class.common?('password')).to be true
      expect(described_class.common?('123456')).to be true
      expect(described_class.common?('qwerty')).to be true
    end

    it 'returns true regardless of case' do
      expect(described_class.common?('PASSWORD')).to be true
      expect(described_class.common?('Password')).to be true
    end

    it 'returns false for uncommon passwords' do
      expect(described_class.common?('xK9#mZ2!pQ7@wR4b')).to be false
      expect(described_class.common?('notacommonpassword99!')).to be false
    end
  end

  describe '.entropy' do
    it 'returns 0.0 for an empty password' do
      expect(described_class.entropy('')).to eq(0.0)
    end

    it 'returns a positive estimate for lowercase-only passwords' do
      expect(described_class.entropy('abcdef')).to be > 0
    end

    it 'returns a larger estimate when multiple character classes are present' do
      simple = described_class.entropy('abcdef')
      complex = described_class.entropy('Abc!ef9#')
      expect(complex).to be > simple
    end
  end

  describe '.score' do
    it 'returns 0 for an empty password' do
      expect(described_class.score('')).to eq(0)
    end

    it 'returns an integer' do
      expect(described_class.score('abc')).to be_a(Integer)
    end

    it 'returns a value in the 0..4 range' do
      expect(described_class.score('MyP@ssw0rd!')).to be_between(0, 4).inclusive
    end

    it 'agrees with the :score key from .strength' do
      %w[a password123 MyP@ssw0rd! c0rr3ctH0rseB4tteryStapl3].each do |pw|
        expect(described_class.score(pw)).to eq(described_class.strength(pw)[:score])
      end
    end

    it 'gives stronger passwords a higher score than weaker ones' do
      expect(described_class.score('aaaaaa')).to be < described_class.score('MyP@ssw0rd!')
    end
  end

  describe '.strength' do
    it 'returns terrible for empty password' do
      result = described_class.strength('')
      expect(result[:score]).to eq(0)
      expect(result[:label]).to eq(:terrible)
      expect(result[:entropy]).to eq(0.0)
    end

    it 'returns terrible for single char "a"' do
      result = described_class.strength('a')
      expect(result[:score]).to eq(0)
      expect(result[:label]).to eq(:terrible)
    end

    it 'returns low score for "password123"' do
      result = described_class.strength('password123')
      expect(result[:score]).to be <= 2
    end

    it 'returns high score for complex long password' do
      result = described_class.strength('C0mpl3x!P@ssw0rd#2026LongEnough')
      expect(result[:score]).to be >= 3
    end

    it 'includes entropy as a float' do
      result = described_class.strength('test')
      expect(result[:entropy]).to be_a(Float)
      expect(result[:entropy]).to be > 0
    end
  end

  describe '.batch_strength' do
    it 'returns an empty array for an empty input' do
      expect(described_class.batch_strength([])).to eq([])
    end

    it 'preserves input order' do
      passwords = ['', 'aaaaaa', 'C0mpl3x!P@ssw0rd#Long']
      results = described_class.batch_strength(passwords)
      scores = results.map { |r| r[:score] }
      expect(scores[0]).to be <= scores[1]
      expect(scores[1]).to be < scores[2]
    end

    it 'returns one strength hash per input' do
      results = described_class.batch_strength(%w[a b c d])
      expect(results.length).to eq(4)
      results.each do |r|
        expect(r).to have_key(:score)
        expect(r).to have_key(:label)
        expect(r).to have_key(:entropy)
      end
    end

    it 'matches single-call strength results' do
      passwords = %w[abc password123 MyP@ssw0rd!]
      batched = described_class.batch_strength(passwords)
      individual = passwords.map { |p| described_class.strength(p) }
      expect(batched).to eq(individual)
    end

    it 'coerces non-string elements via to_s' do
      result = described_class.batch_strength([12_345])
      expect(result.length).to eq(1)
      expect(result.first).to have_key(:score)
    end

    it 'raises ArgumentError for non-enumerable input' do
      expect { described_class.batch_strength(42) }
        .to raise_error(ArgumentError, /enumerable/)
    end
  end

  describe '.generate' do
    context 'with default style (random)' do
      it 'generates password of specified length' do
        password = described_class.generate(length: 20)
        expect(password.length).to eq(20)
      end

      it 'includes required character classes by default' do
        password = described_class.generate(length: 32)
        expect(password).to match(/[a-z]/)
        expect(password).to match(/[A-Z]/)
        expect(password).to match(/\d/)
      end

      it 'generates unique passwords each time' do
        passwords = Array.new(10) { described_class.generate }
        expect(passwords.uniq.length).to eq(10)
      end
    end

    context 'with style: :passphrase' do
      it 'generates passphrase with correct word count' do
        phrase = described_class.generate(style: :passphrase, words: 4, separator: '-')
        words = phrase.split('-')
        expect(words.length).to eq(4)
      end

      it 'uses the specified separator' do
        phrase = described_class.generate(style: :passphrase, words: 3, separator: '.')
        expect(phrase).to include('.')
        expect(phrase.split('.').length).to eq(3)
      end
    end

    context 'with style: :pin' do
      it 'generates digits only' do
        pin = described_class.generate(style: :pin, length: 6)
        expect(pin).to match(/\A\d+\z/)
      end

      it 'generates correct length' do
        pin = described_class.generate(style: :pin, length: 6)
        expect(pin.length).to eq(6)
      end
    end
  end

  describe '.keyboard_patterns' do
    it 'returns an array' do
      result = described_class.keyboard_patterns('test')
      expect(result).to be_an(Array)
    end

    it 'detects qwerty row patterns' do
      result = described_class.keyboard_patterns('myqwertypass')
      expect(result).not_to be_empty
      expect(result.any? { |p| p[:type] == :keyboard_row }).to be true
    end

    it 'detects repeated characters' do
      result = described_class.keyboard_patterns('aaabbb')
      expect(result.any? { |p| p[:type] == :repeated }).to be true
    end

    it 'detects numeric sequences' do
      result = described_class.keyboard_patterns('abc123456def')
      expect(result.any? { |p| p[:type] == :sequence }).to be true
    end
  end

  describe '.zxcvbn' do
    it 'returns a hash with score, patterns, and crack_time_display' do
      result = described_class.zxcvbn('password123')
      expect(result).to have_key(:score)
      expect(result).to have_key(:patterns)
      expect(result).to have_key(:crack_time_display)
    end

    it 'gives low score to common passwords' do
      result = described_class.zxcvbn('password')
      expect(result[:score]).to be <= 1
    end

    it 'gives high score to complex passwords' do
      result = described_class.zxcvbn('X9#kZ!mQ7@wR4bN5&jP2cL8')
      expect(result[:score]).to be >= 3
    end
  end

  describe 'edge cases' do
    it 'handles empty password in policy' do
      policy = Philiprehberger::Password::Policy.new
      result = policy.validate('')
      expect(result.valid?).to be false
    end

    it 'handles very long password in strength' do
      long_pw = 'A1b!' * 100
      result = described_class.strength(long_pw)
      expect(result[:score]).to eq(4)
    end
  end

  describe '.mask' do
    it 'replaces every character with the default mask when visible is 0' do
      expect(described_class.mask('Secret!')).to eq('*******')
    end

    it 'reveals the trailing characters requested' do
      expect(described_class.mask('hunter2', visible: 2)).to eq('*****r2')
    end

    it 'returns the original password when visible exceeds its length' do
      expect(described_class.mask('abc', visible: 10)).to eq('abc')
    end

    it 'accepts a custom mask character' do
      expect(described_class.mask('abcd', mask: '•')).to eq('••••')
    end

    it 'returns an empty string for an empty input' do
      expect(described_class.mask('')).to eq('')
    end

    it 'raises when visible is negative' do
      expect { described_class.mask('abcd', visible: -1) }
        .to raise_error(ArgumentError, /visible/)
    end

    it 'raises when mask is not a single character' do
      expect { described_class.mask('abcd', mask: '**') }
        .to raise_error(ArgumentError, /single character/)
    end
  end
end
