# frozen_string_literal: true

RSpec.describe Philiprehberger::Password::Strength do
  describe '.score' do
    it 'returns terrible for empty password' do
      result = described_class.score('')
      expect(result[:score]).to eq(0)
      expect(result[:label]).to eq(:terrible)
    end

    it 'returns terrible for nil' do
      result = described_class.score(nil)
      expect(result[:score]).to eq(0)
    end

    it 'returns weak for short lowercase' do
      result = described_class.score('abcde')
      expect(result[:score]).to be <= 1
    end

    it 'returns fair for medium password' do
      result = described_class.score('Abcdefgh1')
      expect(result[:score]).to be >= 2
    end

    it 'returns strong or excellent for long complex password' do
      result = described_class.score('C0mpl3x!P@ssw0rd#2026Extra')
      expect(result[:score]).to be >= 3
    end

    it 'includes entropy' do
      result = described_class.score('test')
      expect(result[:entropy]).to be_a(Float)
    end
  end

  describe '.entropy' do
    it 'returns 0 for empty string' do
      expect(described_class.entropy('')).to eq(0.0)
    end

    it 'calculates entropy for lowercase only' do
      entropy = described_class.entropy('abcd')
      expected = 4 * Math.log2(26)
      expect(entropy).to be_within(0.01).of(expected)
    end

    it 'calculates higher entropy for mixed case' do
      entropy = described_class.entropy('aBcD')
      expected = 4 * Math.log2(52)
      expect(entropy).to be_within(0.01).of(expected)
    end

    it 'calculates higher entropy with digits' do
      entropy = described_class.entropy('aB1D')
      expected = 4 * Math.log2(62)
      expect(entropy).to be_within(0.01).of(expected)
    end

    it 'calculates highest entropy with symbols' do
      entropy = described_class.entropy('aB1!')
      expected = 4 * Math.log2(95)
      expect(entropy).to be_within(0.01).of(expected)
    end
  end
end
