# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Password::Policy do
  describe '#validate' do
    let(:policy) { described_class.new }

    it 'returns valid result for good password' do
      result = policy.validate('GoodP@ss123')
      expect(result.valid?).to be true
      expect(result.errors).to be_empty
    end

    it 'rejects nil password' do
      result = policy.validate(nil)
      expect(result.valid?).to be false
      expect(result.errors).to include('Password is required')
    end

    it 'rejects empty password' do
      result = policy.validate('')
      expect(result.valid?).to be false
    end

    it 'rejects short password' do
      result = policy.validate('short')
      expect(result.valid?).to be false
    end

    it 'rejects common passwords by default' do
      result = policy.validate('password')
      expect(result.valid?).to be false
    end

    it 'rejects common passwords from the expanded dictionary' do
      result = policy.validate('qwerty123')
      expect(result.valid?).to be false
      expect(result.errors).to include('password is too common')
    end

    it 'rejects common passwords case-insensitively' do
      result = policy.validate('PASSWORD')
      expect(result.valid?).to be false
      expect(result.errors).to include('password is too common')
    end

    context 'with custom options' do
      let(:strict) do
        described_class.new(
          min_length: 12,
          require_uppercase: true,
          require_lowercase: true,
          require_digit: true,
          require_symbol: true
        )
      end

      it 'enforces all requirements' do
        result = strict.validate('short')
        expect(result.errors.length).to be >= 2
      end

      it 'passes when all requirements met' do
        result = strict.validate('MyStr0ng!Pass')
        expect(result.valid?).to be true
      end
    end

    context 'with common password rejection disabled' do
      let(:lenient) { described_class.new(reject_common: false) }

      it 'allows common passwords' do
        result = lenient.validate('password')
        expect(result.valid?).to be true
      end
    end

    context 'with context-aware validation' do
      it 'rejects passwords containing username' do
        result = policy.validate('myjohnpass1', context: { username: 'john' })
        expect(result.valid?).to be false
        expect(result.errors).to include('must not contain your username')
      end

      it 'rejects passwords containing username case-insensitively' do
        result = policy.validate('myJOHNpass1', context: { username: 'john' })
        expect(result.valid?).to be false
        expect(result.errors).to include('must not contain your username')
      end

      it 'rejects passwords containing email address' do
        result = policy.validate('john@example.com!1A', context: { email: 'john@example.com' })
        expect(result.valid?).to be false
        expect(result.errors).to include('must not contain your email address')
      end

      it 'rejects passwords containing email local part' do
        result = policy.validate('myjohnpass1', context: { email: 'john@example.com' })
        expect(result.valid?).to be false
        expect(result.errors).to include('must not contain your email username')
      end

      it 'rejects passwords containing app name' do
        result = policy.validate('myacmeapp1!', context: { app_name: 'acme' })
        expect(result.valid?).to be false
        expect(result.errors).to include('must not contain the application name')
      end

      it 'passes when password does not contain context values' do
        result = policy.validate('Str0ng!Pwd', context: { username: 'john', email: 'john@ex.com', app_name: 'acme' })
        expect(result.valid?).to be true
      end

      it 'skips context check for very short usernames' do
        result = policy.validate('SomeP@ss1', context: { username: 'ab' })
        expect(result.valid?).to be true
      end

      it 'handles empty context gracefully' do
        result = policy.validate('GoodP@ss123', context: {})
        expect(result.valid?).to be true
      end

      it 'handles nil context gracefully' do
        result = policy.validate('GoodP@ss123', context: nil)
        expect(result.valid?).to be true
      end

      it 'reports multiple context violations' do
        result = policy.validate('johnjohnacme1', context: { username: 'john', app_name: 'acme' })
        expect(result.errors).to include('must not contain your username')
        expect(result.errors).to include('must not contain the application name')
      end
    end
  end
end
