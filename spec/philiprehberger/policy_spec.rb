# frozen_string_literal: true

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
  end
end
