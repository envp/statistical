require 'spec_helper'
require 'statistical/rng/uniform_discrete'
require 'statistical/distribution/uniform_discrete'

describe Statistical::Rng::UniformDiscrete do
  it 'passes the G-test at a 95% significance level'

  describe '.new'
  describe '#rand'
end

describe Statistical::Distribution::UniformDiscrete do
  describe '.new' do
    context 'when parameters are specified' do
      let(:size) {10}
      let(:elems) {Array.new(size) {rand}}
      let(:arg_range) {0..9}
      let(:arg_fixnum) {100}
      let(:arg_bignum) {10000000000000000000000000000000000000000}
      let(:udist) {Statistical::Distribution::UniformDiscrete.new(elems)}

      it 'accepts an array as an argument' do
        expect {
          Statistical::Distribution::UniformDiscrete.new(elems)
        }.not_to raise_error
      end

      it 'accepts a range as an argument' do
        expect {
          Statistical::Distribution::UniformDiscrete.new(arg_range)
        }.not_to raise_error
      end

      it 'accepts a single Fixnum as an argument' do
        expect {
          Statistical::Distribution::UniformDiscrete.new(arg_fixnum)
        }.not_to raise_error
      end

      it 'accepts a single Bignum as an argument' do
        expect {
          Statistical::Distribution::UniformDiscrete.new(arg_bignum)
        }.not_to raise_error
      end

      it 'sets the right lower bound' do
        expect(udist.lower).to eq(elems.min)
      end

      it 'sets the right upper bound' do
        expect(udist.upper).to eq(elems.max)
      end
      
      it 'sorts(asc) the element array given as an argument' do
        expect(udist.support).to eq(elems.sort)
      end
    end
  end

  describe '#pdf' do
    let(:size) {10}
    let(:epsilon) {1e-9}
    let(:elems) {Array.new(size) {rand}}
    let(:udist) {Statistical::Distribution::UniformDiscrete.new(elems)}
    
    context 'when called with x < lower_bound' do
      it {expect(udist.pdf(udist.lower - epsilon)).to eq(0)}
    end

    context 'when called with x > upper_bound' do
      it {expect(udist.pdf(udist.upper + epsilon)).to eq(0)}
    end

    context 'when called with x in [lower_bound, upper_bound]' do
      it 'should be evaluated correctly if x is a member of the support set' do
        expect(udist.pdf(elems[rand(size)])).to eq(1.fdiv(size))
      end
      
      it 'should be 0 x is not a member of the support set' do
        expect(udist.pdf(elems[rand(size)] - epsilon)).to eq(0)
      end
    end
  end

  describe '#cdf' do
    let(:size) {10}
    let(:epsilon) {1e-9}
    let(:elems) {Array.new(size) {rand}}
    let(:udist) {Statistical::Distribution::UniformDiscrete.new(elems)}
    
    context 'when called with x < lower' do
      it {expect(udist.cdf(udist.lower - epsilon)).to eq(0)}
    end

    context 'when called with x > upper' do
      it {expect(udist.cdf(udist.upper + epsilon)).to eq(1)}
    end

    context 'when called with x in [lower, upper]' do
      it 'returns k/n where `k` is the index of smallest element larger than x' do
        x = udist.lower + rand * (udist.upper - udist.lower)
        ex = nil
        (0..size).each {|i| ((ex = i) && break) if x <= udist.support[i]}
        expect(udist.cdf(x)).to eq(ex.fdiv(size))
      end
    end
  end

  describe '#quantile' do
    let(:epsilon) {1e-9}
    let(:elems) {(0..9).to_a}
    let(:ex) {elems[rand(size)] + rand}
    let(:size) {elems.length}
    let(:udist) {Statistical::Distribution::UniformDiscrete.new(elems)}
    
    context 'when called for x > 1' do
      it {expect {udist.quantile(2)}.to raise_error(RangeError)}
    end

    context 'when called for x < 0' do
      it {expect {udist.quantile(-1)}.to raise_error(RangeError)}
    end

    context 'when called for x in [0, 1] when support is' do
      it 'inverts the cdf(1) method' do
        # any number n + d should have percentile (n + 1) / 10 for 0..9
        # if d is in [0, 1]
        x = udist.quantile(udist.cdf(ex))
        expect(ex.floor).to eq(x)
      end
      
      it 'is inverted by the cdf(1) method' do
        p = rand
        el = (p * size).ceil
        x = udist.cdf(udist.quantile(p))
        expect(el).to eq(x * size)
      end
    end
  end

  describe '#p_value' do
    let(:size) {10}
    let(:elems) {Array.new(size) {rand}}
    let(:udist) {Statistical::Distribution::UniformDiscrete.new(elems)}
    it 'should be the same as #quantile' do
      x = rand
      expect(udist.quantile(x)).to eq(udist.p_value(x))
    end
  end

  describe '#mean' do
    let(:size) {10}
    let(:epsilon) {1e-9}
    let(:elems) {(1..10).to_a}
    let(:udist) {Statistical::Distribution::UniformDiscrete.new(elems)}
    
    it 'should return the correct mean' do
      expect(udist.mean).to eq(elems.mean)
    end
  end

  describe '#variance' do
    let(:size) {10}
    let(:epsilon) {1e-9}
    let(:elems) {(1..10).to_a}
    let(:udist) {Statistical::Distribution::UniformDiscrete.new(elems)}
    
    it 'should return the correct variance for 1..10' do
      expect(udist.variance).to eq(elems.variance)
    end
  end

  describe '#==' do
    context 'when compared against another Uniform distribution' do
      it 'returns `true` if they have the same parameters' do
        skip("FIXME: Comparison currently broken")
      end

      it 'returns `false` if they have different parameters' do
        skip("FIXME: Comparison currently broken")
      end
    end

    context 'when compared against any distribution type' do
      skip("FIXME: Comparison currently broken")
    end
  end
end
