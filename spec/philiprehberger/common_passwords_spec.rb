# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Password::CommonPasswords do
  describe '.include?' do
    it 'detects common passwords' do
      expect(described_class.include?('password')).to be true
      expect(described_class.include?('123456')).to be true
      expect(described_class.include?('qwerty')).to be true
    end

    it 'is case-insensitive' do
      expect(described_class.include?('PASSWORD')).to be true
      expect(described_class.include?('Password')).to be true
      expect(described_class.include?('QWERTY')).to be true
    end

    it 'returns false for non-common passwords' do
      expect(described_class.include?('xK9#mZ2!pQ7@wR4b')).to be false
    end

    it 'handles empty string' do
      expect(described_class.include?('')).to be false
    end

    it 'handles nil input' do
      expect(described_class.include?(nil)).to be false
    end

    it 'detects passwords from the expanded list' do
      expect(described_class.include?('dragon')).to be true
      expect(described_class.include?('letmein')).to be true
      expect(described_class.include?('trustno1')).to be true
      expect(described_class.include?('iloveyou')).to be true
    end
  end

  describe '.size' do
    it 'contains a substantial number of passwords' do
      expect(described_class.size).to be > 500
    end
  end

  describe 'PASSWORDS constant' do
    it 'is a frozen Set' do
      expect(described_class::PASSWORDS).to be_a(Set)
      expect(described_class::PASSWORDS).to be_frozen
    end

    it 'contains only lowercase entries' do
      described_class::PASSWORDS.each do |pwd|
        expect(pwd).to eq(pwd.downcase), "Expected '#{pwd}' to be lowercase"
      end
    end
  end
end
