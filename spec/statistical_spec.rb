require 'spec_helper'
require 'statistical/helpers'

describe Statistical do
  describe Statistical::Domain do
    exclude = [1, 2, 3, 4]
    d = Statistical::Domain[0, 5, :closed, *exclude]

    it {expect(Statistical::Domain.superclass).to eq(Range)}

    it '::[begin, end, type] creates a new instance' do
      expect(Statistical::Domain[1, 2, :closed]).to be_a(Statistical::Domain)
    end

    it 'adds elements in the exclusion list at initialization' do
      expect(d.exclusions).to eq(exclude)
    end

    it 'does not include elements in the exclusion list' do
      expect(d.include?(exclude[rand(exclude.size)])).to be false
    end
  end
end
