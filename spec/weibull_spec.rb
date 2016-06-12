require 'spec_helper'
require 'statistical/rng/weibull'
require 'statistical/distribution/weibull'

describe Statistical::Rng::Weibull do
  describe '.new' do
    context 'when called with no arguments' do
      let(:wrng)  {Statistical::Rng::Weibull.new}

      it 'should have scale = 1' do
        expect(wrng.scale).to be_within(Float::EPSILON).of(1)
      end

      it 'should have shape = 1' do
        expect(wrng.shape).to be_within(Float::EPSILON).of(1)
      end
    end

    context 'when parameters are specified' do
      let(:scale) {0.1 + rand}
      let(:shape) {0.1 + rand}
      let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}
      let(:wrng)  {Statistical::Rng::Weibull.new(wdist)}

      it 'should have the correct scale parameter set' do
        expect(wrng.scale).to be_within(Float::EPSILON).of(scale)
      end

      it 'should have the correct shape parameter set' do
        expect(wrng.shape).to be_within(Float::EPSILON).of(shape)
      end
    end

    context 'when initialized with a seed' do
      let(:scale)   {0.1 + rand}
      let(:shape)   {0.1 + rand}
      let(:seed)    {Random.new_seed}
      let(:wdist)   {Statistical::Distribution::Weibull.new(scale, shape)}
      let(:wrng_a)  {Statistical::Rng::Weibull.new(wdist, seed)}
      let(:wrng_b)  {Statistical::Rng::Weibull.new(wdist, seed)}

      it 'should be repeatable for the same arguments' do
        expect(wrng_a.rand).to eq(wrng_b.rand)
      end
    end
  end

  describe '#rand' do
    it 'passes the G-test at a 95% significance level'
  end

  describe '#==' do
    context 'when compared against another uniform distribution' do
      let(:scale)   {0.1 + rand}
      let(:shape)   {0.1 + rand}
      let(:seed_a)  {Random.new_seed}
      let(:seed_b)  {Random.new_seed}
      let(:wdist_a) {Statistical::Distribution::Weibull.new(scale, shape)}
      let(:wdist_b) {Statistical::Distribution::Weibull.new(scale, shape)}
      let(:wrng_a)  {Statistical::Rng::Weibull.new(wdist_a, seed_a)}
      let(:wrng_b)  {Statistical::Rng::Weibull.new(wdist_b, seed_b)}
      let(:wrng_c)  {Statistical::Rng::Weibull.new(wdist_a, seed_a)}

      it 'should return true if the arguments are the same' do
        expect(wrng_a == wrng_c).to be true
      end

      it 'should return false if bounds / seed differ' do
        expect(wrng_a == wrng_b).to be false
      end
    end
  end
end


describe Statistical::Distribution::Weibull do
  describe '.new' do
    context 'when called with no arguments' do
      let(:wdist) {Statistical::Distribution::Weibull.new}

      it 'should have scale = 1' do
        expect(wdist.scale).to be_within(Float::EPSILON).of(1.0)
      end

      it 'should have shape = 1' do
        expect(wdist.shape).to be_within(Float::EPSILON).of(1.0)
      end
    end

    context 'when upper and lower bounds are specified' do
      let(:scale) {0.1 + rand}
      let(:shape) {0.1 + rand}
      let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}

      it 'should have the correct scale parameter set' do
        expect(wdist.scale).to be_within(Float::EPSILON).of(scale)
      end

      it 'should have the correct shape parameter set' do
        expect(wdist.shape).to be_within(Float::EPSILON).of(shape)
      end
    end
  end

  describe '#pdf' do
    context 'when called with x < lower_bound' do
      let(:wdist) {Statistical::Distribution::Weibull.new}

      it {expect(wdist.pdf(-Float::EPSILON)).to be_within(Float::EPSILON).of(0)}
    end

    context 'when called with x in [lower_bound, upper_bound]' do
      let(:scale) {0.1 + rand}
      let(:shape) {0.1 + rand}
      let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}
      let(:x)     {rand}

      it 'returns a value consistent with the weibull PDF' do
        expect(wdist.pdf(x)).to eq(
          (shape / scale) *
          ((x / scale) ** (shape - 1)) *
          Math.exp(-(x / scale) ** shape)
        )
      end
    end
  end

  describe '#cdf' do
    context 'when called with x < lower' do
      let(:wdist) {Statistical::Distribution::Weibull.new}

      it {expect(wdist.cdf(-Float::EPSILON)).to be_within(Float::EPSILON).of(0)}
    end

    context 'when called with x in [lower, upper]' do
      let(:scale) {0.1 + rand}
      let(:shape) {0.1 + rand}
      let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}
      let(:x)     {rand}

      it 'returns a value consistent with the weibull PMF' do
        expect(wdist.cdf(x)).to be_within(Float::EPSILON).of(1 - Math.exp(-(x / scale) ** shape))
      end

    end
  end

  describe '#quantile' do
    context 'when called for x > 1' do
      let(:wdist) {Statistical::Distribution::Weibull.new}

      it {expect {wdist.quantile(-Float::EPSILON)}.to raise_error RangeError}
    end

    context 'when called for x < 0' do
      let(:wdist) {Statistical::Distribution::Weibull.new}

      it {expect {wdist.quantile(1 + Float::EPSILON)}.to raise_error RangeError}
    end

    context 'when called for x in [0, 1]' do
      let(:scale) {0.1 + rand}
      let(:shape) {0.1 + rand}
      let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}
      let(:x)     {rand}

      it {
        expect(wdist.quantile(x)).to be_within(Float::EPSILON).of(
          scale * ((-Math.log(1 - x)) ** (1 / shape))
        )
      }
    end
  end

  describe '#p_value' do
    let(:scale) {0.1 + rand}
    let(:shape) {0.1 + rand}
    let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}
    let(:x) {rand}

    it 'should be the same as #quantile' do
      expect(wdist.p_value(x)).to be_within(Float::EPSILON).of(wdist.quantile(x))
    end
  end

  describe '#mean' do
    let(:scale) {0.1 + rand}
    let(:shape) {0.1 + rand}
    let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}

    it 'should return the correct mean' do
      expect(wdist.mean).to be_within(Float::EPSILON).of(
        scale * Math.gamma(1 + 1 / shape)
      )
    end
  end

  describe '#variance' do
    let(:scale) {0.1 + rand}
    let(:shape) {0.1 + rand}
    let(:wdist) {Statistical::Distribution::Weibull.new(scale, shape)}

    it 'should return the correct variance' do
      expect(wdist.variance).to be_within(Float::EPSILON).of(
        (scale ** 2) * (
          Math.gamma(1 + 2 / shape) - (Math.gamma(1 + 1 / shape)) ** 2
        )
      )
    end
  end

  describe '#==' do
    context 'when compared against another Uniform distribution' do
      let(:scale_a) {0.1 + rand}
      let(:shape_a) {0.1 + rand}
      let(:scale_b) {0.1 + rand}
      let(:shape_b) {0.1 + rand}
      let(:wdist_a) {Statistical::Distribution::Weibull.new(scale_a, shape_a)}
      let(:wdist_c) {Statistical::Distribution::Weibull.new(scale_a, shape_a)}
      let(:wdist_b) {Statistical::Distribution::Weibull.new(scale_b, shape_b)}

      it 'returns `true` if they have the same parameters' do
        expect(wdist_a == wdist_c).to be true
      end

      it 'returns `false` if they have different parameters' do
        expect(wdist_a == wdist_b).to be false
      end
    end
  end
end
