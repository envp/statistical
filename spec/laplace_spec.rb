require 'spec_helper'
require 'statistical/rng/laplace'
require 'statistical/distribution/laplace'

describe Statistical::Rng::Laplace do
  it 'passes the G-test at a 95% significance level' do
    skip("TODO: Add tests")
  end

  describe '.new' do
    context 'when called with no arguments' do
      skip("TODO: Add tests")
    end

    context 'when parameters are specified' do
      skip("TODO: Add tests")
    end

    context 'when initialized with a seed' do
      it 'should be repeatable for the same arguments' do
        skip("TODO: Add tests")
      end
    end
  end

  describe '#rand' do
    it 'returns a number between 0 and 1 by default' do
      skip("TODO: Add tests")
    end

    it 'returns a bounded value when bounds are specified' do
      skip("TODO: Add tests")
    end
  end

  describe '#==' do
    context 'when compared against another uniform distribution' do
      it 'should return true if the bounds and seed are the same' do
        skip("TODO: Add tests")
      end

      it 'should return false if bounds / seed differ' do
        skip("TODO: Add tests")
      end
    end

    context 'when compared against any other distribution class' do
      it 'should return false if classes are different' do
        skip("TODO: Add tests")
      end
    end
  end
end


describe Statistical::Distribution::Laplace do
  describe '.new' do
    context 'when called with no arguments' do
      let(:ldist) {Statistical::Distribution::Laplace.new}
      
      it "should have location set to 0" do
        expect(ldist.location).to eq(0.0)
      end
      
      it "should have scale set to 1" do
        expect(ldist.scale).to eq(1.0)
      end
    end
    
    context 'when parameters are specified' do
      let(:location) {rand}
      let(:scale) {1 + rand}
      let(:ldist) {Statistical::Distribution::Laplace.new(location, scale)}
      
      it 'should have the right location set' do
        expect(ldist.location).to eq(location)
      end
      
      it 'should have the right scale set' do
        expect(ldist.scale).to eq(scale)
      end
    end
  end
  
  
  describe '#pdf' do
    let(:location) {rand}
    let(:scale) {1 + rand}
    let(:ldist) {Statistical::Distribution::Laplace.new(location, scale)}
    let(:delta) {rand}
    
    it 'should have a symmetric pdf' do
      expect(ldist.pdf(location - delta)).to be_within(Float::EPSILON).of(
        ldist.pdf(location + delta)
      )
    end
    
    it 'should have a exponential pdf centered about the `location` param' do
      expect(ldist.pdf(location + delta)).to be_within(Float::EPSILON).of(
        0.5 * Math.exp(-1 * delta / scale) / scale
      )
    end
  end
  
  describe '#cdf' do
    let(:location) {rand}
    let(:scale) {1 + rand}
    let(:ldist) {Statistical::Distribution::Laplace.new(location, scale)}
    
    it 'should be 0.5 at the distribution centre' do
      expect(ldist.cdf(location)).to eq(0.5)
    end
    
    it 'should be 0 at -Infinity' do
      expect(ldist.cdf(-Float::INFINITY)).to eq(0)
    end
    
    it 'should be 1 at +Infinity' do
      expect(ldist.cdf(Float::INFINITY)).to eq(1)
    end
  end
  
  describe '#quantile' do
    context 'when called for x > 1' do
      let(:ldist) {Statistical::Distribution::Laplace.new}
      let(:epsilon) {Float::EPSILON}
      it {expect {ldist.quantile(1 + epsilon)}.to raise_error(RangeError)}
    end
    
    context 'when called for x < 0' do
      let(:ldist) {Statistical::Distribution::Laplace.new}
      let(:epsilon) {Float::EPSILON}
      it {expect {ldist.quantile(-epsilon)}.to raise_error(RangeError)}
    end
    
    context 'when called for x in [0, 1]' do
      let(:ldist) {Statistical::Distribution::Laplace.new}
      let(:lo) {rand / 2}
      let(:hi) {(1.0 + rand) / 2}
      
      it 'for p < 0.5' do
        expect(ldist.quantile(lo)).to be_within(Float::EPSILON).of(
          Math.log(2 * lo)
        )
      end
      
      it 'for p >= 0.5' do
        expect(ldist.quantile(hi)).to be_within(Float::EPSILON).of(
          -Math.log(2 * (1 - hi))
        )
      end
    end
  end
  
  describe '#p_value' do
    let(:ldist) {Statistical::Distribution::Laplace.new}
    let(:x) {rand}
    
    it 'should be the same as #quantile' do
      expect(ldist.quantile(x)).to eq(ldist.p_value(x))
    end
  end  
  
  describe '#mean' do
    let(:location) {rand}
    let(:scale) {1 + rand}
    let(:ldist) {Statistical::Distribution::Laplace.new(location, scale)}
    
    it 'should return the correct mean' do
      expect(ldist.mean).to eq(location)
    end
  end
  
  describe '#variance' do
    let(:location) {rand}
    let(:scale) {1 + rand}
    let(:ldist) {Statistical::Distribution::Laplace.new(location, scale)}
    
    it 'should return the correct variance' do
      expect(ldist.variance).to eq(2 * scale * scale)
    end
  end
  
  describe '#==' do
    context 'when compared against another Uniform distribution' do
      let(:loc_a) {rand}
      let(:scl_a) {1 + rand}
      let(:loc_b) {rand}
      let(:scl_b) {1 + rand}
      
      let(:ldist_a) {Statistical::Distribution::Laplace.new(loc_a, scl_a)}
      let(:ldist_a_clone) {Statistical::Distribution::Laplace.new(loc_a, scl_a)}
      let(:ldist_b) {Statistical::Distribution::Laplace.new(loc_b, scl_b)}
      
      it 'returns `true` if they have the same parameters' do
        expect(ldist_a == ldist_a_clone).to be true
      end
      
      it 'returns `false` if they have different parameters' do
        expect(ldist_a == ldist_b).to be false
      end
    end
    
    context 'when compared against any distribution type' do
      skip("Pending implementation")
    end
  end
end