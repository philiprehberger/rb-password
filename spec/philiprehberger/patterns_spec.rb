# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Password::Patterns do
  describe '.detect' do
    it 'returns empty array for empty password' do
      expect(described_class.detect('')).to eq([])
    end

    it 'returns empty array for nil' do
      expect(described_class.detect(nil)).to eq([])
    end

    it 'returns empty array for password with no patterns' do
      result = described_class.detect('X9kZ2mQ7')
      expect(result).to be_empty
    end

    context 'keyboard row detection' do
      it 'detects qwerty row pattern' do
        result = described_class.detect('myqwertypass')
        keyboard = result.select { |p| p[:type] == :keyboard_row }
        expect(keyboard).not_to be_empty
        expect(keyboard.first[:token].downcase).to include('qwert')
      end

      it 'detects asdf row pattern' do
        result = described_class.detect('myasdfgpass')
        keyboard = result.select { |p| p[:type] == :keyboard_row }
        expect(keyboard).not_to be_empty
      end

      it 'detects zxcvbn row pattern' do
        result = described_class.detect('myzxcvbpass')
        keyboard = result.select { |p| p[:type] == :keyboard_row }
        expect(keyboard).not_to be_empty
      end

      it 'detects reverse keyboard patterns' do
        result = described_class.detect('poiuypass')
        keyboard = result.select { |p| p[:type] == :keyboard_row }
        expect(keyboard).not_to be_empty
        expect(keyboard.first[:direction]).to eq(:reverse)
      end

      it 'detects numeric row pattern' do
        result = described_class.detect('my12345pass')
        patterns = result.select { |p| %i[keyboard_row sequence].include?(p[:type]) }
        expect(patterns).not_to be_empty
      end

      it 'includes start position' do
        result = described_class.detect('XXqwertyXX')
        keyboard = result.select { |p| p[:type] == :keyboard_row }
        expect(keyboard).not_to be_empty
        expect(keyboard.first[:start]).to eq(2)
      end
    end

    context 'sequence detection' do
      it 'detects ascending alphabetic sequence' do
        result = described_class.detect('myabcdefpass')
        sequences = result.select { |p| p[:type] == :sequence && p[:sequence_type] == :alphabetic }
        expect(sequences).not_to be_empty
        expect(sequences.first[:direction]).to eq(:ascending)
      end

      it 'detects descending alphabetic sequence' do
        result = described_class.detect('myfedcbapass')
        sequences = result.select { |p| p[:type] == :sequence && p[:sequence_type] == :alphabetic }
        expect(sequences).not_to be_empty
        expect(sequences.first[:direction]).to eq(:descending)
      end

      it 'detects ascending numeric sequence' do
        result = described_class.detect('my123456pass')
        sequences = result.select { |p| p[:type] == :sequence && p[:sequence_type] == :numeric }
        expect(sequences).not_to be_empty
      end

      it 'detects descending numeric sequence' do
        result = described_class.detect('my654321pass')
        sequences = result.select { |p| p[:type] == :sequence && p[:sequence_type] == :numeric }
        expect(sequences).not_to be_empty
        expect(sequences.first[:direction]).to eq(:descending)
      end

      it 'does not detect sequences shorter than 3 characters' do
        result = described_class.detect('ab12xy')
        expect(result).to be_empty
      end
    end

    context 'repeated character detection' do
      it 'detects repeated characters' do
        result = described_class.detect('myaaabbbpass')
        repeated = result.select { |p| p[:type] == :repeated }
        expect(repeated.length).to eq(2)
      end

      it 'returns the repeated character' do
        result = described_class.detect('aaaa')
        expect(result.first[:repeated_char]).to eq('a')
      end

      it 'returns correct length of repetition' do
        result = described_class.detect('zzzzz')
        expect(result.first[:length]).to eq(5)
      end

      it 'does not detect repetitions shorter than 3' do
        result = described_class.detect('aabb')
        repeated = result.select { |p| p[:type] == :repeated }
        expect(repeated).to be_empty
      end

      it 'detects multiple separate repetitions' do
        result = described_class.detect('aaaxbbb')
        repeated = result.select { |p| p[:type] == :repeated }
        expect(repeated.length).to eq(2)
      end
    end

    context 'mixed patterns' do
      it 'detects both sequences and repetitions in one password' do
        result = described_class.detect('aaa123456bbb')
        types = result.map { |p| p[:type] }.uniq
        expect(types).to include(:repeated)
        expect(types).to include(:sequence)
      end
    end
  end
end
