require 'spec_helper'
require 'statistical/rng'

describe Statistical::Rng do
  describe '.create' do
    context 'when the parameter `type` is blank' do
      it 'returns an object of type Statistical::Rng::Uniform' do
        obj = Statistical::Rng.create
        expect(obj).to be_a(Statistical::Rng::Uniform)
      end
    end

    context 'when the parameter `type` is :uniform' do
      it 'returns an object of type Statistical::Rng::Uniform' do
        obj = Statistical::Rng.create(:uniform)
        expect(obj).to be_a(Statistical::Rng::Uniform)
      end
    end
  end
end
