require 'spec_helper'
require 'statistical/rng/laplace'
require 'statistical/distribution/laplace'

describe Statistical::Rng::Laplace do
  describe '.new' do
    context 'when called with no arguments' do
      let(:ldist) {Statistical::Distribution::Laplace.new}
      let(:lrng)  {Statistical::Rng::Laplace.new(ldist)}

      it 'should be located at x = 0' do
        expect(lrng.location).to eq(0)
      end

      it 'should have scale = 1' do
        expect(lrng.scale).to eq(1)
      end
    end

    context 'when parameters are specified' do
      let(:loc)   {rand - 0.5}
      let(:scl)   {rand + 0.1}
      let(:ldist) {Statistical::Distribution::Laplace.new(loc, scl)}
      let(:lrng)  {Statistical::Rng::Laplace.new(ldist)}

      it 'should have the right location parameter' do
        expect(lrng.location).to eq(loc)
      end

      it 'should have the right scale parameter' do
        expect(lrng.scale).to eq(scl)
      end
    end

    context 'when initialized with a seed' do
      let(:loc)     {rand - 0.5}
      let(:scl)     {rand + 0.1}
      let(:seed)    {Random.new_seed}
      let(:ldist)   {Statistical::Distribution::Laplace.new(loc, scl)}
      let(:lrng_a)  {Statistical::Rng::Laplace.new(ldist, seed)}
      let(:lrng_b)  {Statistical::Rng::Laplace.new(ldist, seed)}

      it 'should be repeatable for the same arguments' do
        expect(lrng_a.rand).to eq(lrng_b.rand)
      end
    end
  end

  describe '#rand' do
    it 'passes the G-test at a 95% significance level'
  end

  describe '#==' do
    context 'when compared against another laplace distribution' do
      let(:loc_a)     {rand - 0.5}
      let(:loc_b)     {rand - 0.5}
      let(:scl_a)     {rand + 0.1}
      let(:scl_b)     {rand + 0.1}
      let(:seed)      {Random.new_seed}

      let(:ldist_a)   {Statistical::Distribution::Laplace.new(loc_a, scl_a)}
      let(:ldist_b)   {Statistical::Distribution::Laplace.new(loc_b, scl_b)}
      let(:ldist_c)   {Statistical::Distribution::Laplace.new(loc_a, scl_a)}

      let(:lrng_a)    {Statistical::Rng::Laplace.new(ldist_a, seed)}
      let(:lrng_b)    {Statistical::Rng::Laplace.new(ldist_b, seed)}
      let(:lrng_c)    {Statistical::Rng::Laplace.new(ldist_c, seed)}

      it 'should return true if the bounds and seed are the same' do
        expect(lrng_a == lrng_c).to be true
      end

      it 'should return false if parameters differ' do
        expect(lrng_a == lrng_b).to be false
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
    context 'when compared against another two-point distribution' do
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
  end
end
