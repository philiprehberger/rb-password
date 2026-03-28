# frozen_string_literal: true

require 'spec_helper'

bcrypt_available = begin
  require 'bcrypt'
  true
rescue LoadError
  false
end

RSpec.describe Philiprehberger::Password::Hashing, if: bcrypt_available do
  describe '.hash' do
    it 'returns a bcrypt hash string' do
      hash = described_class.hash('mysecretpassword')
      expect(hash).to be_a(String)
      expect(hash).to start_with('$2')
    end

    it 'returns different hashes for the same password' do
      hash1 = described_class.hash('mysecretpassword')
      hash2 = described_class.hash('mysecretpassword')
      expect(hash1).not_to eq(hash2)
    end

    it 'accepts a custom cost factor' do
      hash = described_class.hash('test', cost: 4)
      expect(hash).to be_a(String)
      expect(hash).to start_with('$2')
    end

    it 'uses default cost of 12' do
      expect(described_class::DEFAULT_COST).to eq(12)
    end
  end

  describe '.verify' do
    it 'returns true for matching password' do
      hash = described_class.hash('correct-horse-battery', cost: 4)
      expect(described_class.verify('correct-horse-battery', hash)).to be true
    end

    it 'returns false for non-matching password' do
      hash = described_class.hash('correct-horse-battery', cost: 4)
      expect(described_class.verify('wrong-password', hash)).to be false
    end

    it 'handles empty password' do
      hash = described_class.hash('', cost: 4)
      expect(described_class.verify('', hash)).to be true
      expect(described_class.verify('notempty', hash)).to be false
    end
  end

  describe 'module-level API' do
    it 'is accessible via Password.hash' do
      hash = Philiprehberger::Password.hash('test123', cost: 4)
      expect(hash).to start_with('$2')
    end

    it 'is accessible via Password.verify' do
      hash = Philiprehberger::Password.hash('test123', cost: 4)
      expect(Philiprehberger::Password.verify('test123', hash)).to be true
    end
  end
end
