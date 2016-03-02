require 'spec_helper'
require 'statistical/distribution'

describe Statistical::Distribution do
  describe '.create' do
    context 'when the parameter `type` is blank' do
      let(:obj) {Statistical::Distribution.create}
      it 'returns an object of type Statistical::Distribution::Uniform' do
        expect(obj).to be_a(Statistical::Distribution::Uniform)
      end
    end

    context 'when the parameter `type` is specified' do
      it 'should create the right Distribution type'
    end
  end
end
