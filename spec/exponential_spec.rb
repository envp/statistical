require 'spec_helper'
require 'statistical/rng/exponential'
require 'statistical/distribution/exponential'

describe Statistical::Rng::Exponential do
  it 'passes the G-test at a 95% significance level' do
  end

  describe '.new' do
    context 'when called with no arguments' do
      let(:erng) {Statistical::Rng::Exponential.new}

      it "has a unit rate parameter" do
        expect(erng.rate).to eq(1)
      end
    end

    context 'when parameters are specified' do
      let(:rate) {rand(10)}
      let(:edist) {Statistical::Distribution::Exponential.new(rate)}
      let(:erng) {Statistical::Rng::Exponential.new(edist)}

      it "is initialized with the correct rate parameter" do
        expect(erng.rate).to eq(rate)
      end
    end

    context 'when initialized with a seed' do
      let(:rate) {0.5}
      let(:seed) {Random.new_seed}
      let(:edist) {Statistical::Distribution::Exponential.new(rate)}
      let(:erng) {Statistical::Rng::Exponential.new(edist, seed)}
      let(:erng_clone) {Statistical::Rng::Exponential.new(edist, seed)}

      it 'should be repeatable for the same arguments' do
        expect(erng.rand).to eq(erng_clone.rand)
      end
    end
  end

  describe '#rand' do
    let(:erng) {Statistical::Rng::Exponential.new}
    let(:bound) {rand}
    it 'returns a positive number by default' do
      expect(erng.rand).to be > 0
    end
  end

  describe '#==' do
    context 'when compared against another uniform distribution' do
      let(:rate) {0.5}

      let(:seed) {Random.new_seed}
      let(:seed_alt) {seed / 2}

      let(:edist) {Statistical::Distribution::Exponential.new(rate)}

      let(:erng) {Statistical::Rng::Exponential.new(edist, seed)}
      let(:erng_clone) {Statistical::Rng::Exponential.new(edist, seed)}

      let(:erng_alt) {Statistical::Rng::Exponential.new(edist, seed_alt)}

      it 'should return true if the parameters and seed are the same' do
        expect(erng).to eq(erng_clone)
      end

      it 'should return false if parameters differ' do
        expect(erng).not_to eq(erng_alt)
      end
    end

    context 'when compared against any other distribution class' do
      it 'should return false if classes are different' do
        skip
      end
    end
  end
end

describe Statistical::Distribution::Exponential do
  describe '.new' do
    context 'when called with no arguments' do
      let(:edist) {Statistical::Distribution::Exponential.new}

      it {expect(edist.rate).to eq(1)}
    end

    context 'when upper and lower bounds are specified' do
      let(:rate) {rand(3)}
      let(:edist) {Statistical::Distribution::Exponential.new(rate)}

      it {expect(edist.rate).to eq(rate)}
    end
  end

  describe '#pdf' do
    context 'when called with x < 0' do
      let(:edist) {Statistical::Distribution::Exponential.new}
      it {expect(edist.pdf(0 - Float::EPSILON)).to eq(0)}
    end

    context 'when called with x in [lower_bound, upper_bound]' do
      let(:edist) {Statistical::Distribution::Exponential.new}
      let(:x) {rand(20)}

      it {expect(edist.pdf(x)).to eq(Math.exp(-x))}
    end
  end

  describe '#cdf' do
    context 'when called with x < lower' do
      let(:edist) {Statistical::Distribution::Exponential.new}
      it {expect(edist.cdf(0 - Float::EPSILON)).to eq(0)}
    end

    context 'when called with x in [lower, upper]' do
      let(:edist) {Statistical::Distribution::Exponential.new}
      let(:x) {rand(20)}

      it {expect(edist.pdf(x)).to eq(Math.exp(-x))}
    end
  end

  describe '#quantile' do
    context 'when called for x > 1' do
      let(:edist) {Statistical::Distribution::Exponential.new}
      let(:x) {1 + Float::EPSILON}

      it {expect {edist.quantile(x)}.to raise_error(RangeError)}
    end

    context 'when called for x < 0' do
      let(:edist) {Statistical::Distribution::Exponential.new}
      let(:x) {0 - Float::EPSILON}

      it {expect {edist.quantile(x)}.to raise_error(RangeError)}
    end

    context 'when called for x in [0, 1]' do
      let(:edist) {Statistical::Distribution::Exponential.new}
      let(:x) {rand}

      it {expect(edist.quantile(x)).to eq(-Math.log(1 - x))}
    end
  end

  describe '#p_value' do
    let(:edist) {Statistical::Distribution::Exponential.new}
    let(:x) {rand}

    it 'should be the same as #quantile' do
      expect(edist.quantile(x)).to eq(edist.p_value(x))
    end
  end

  describe '#mean' do
    let(:rate) {0.6}
    let(:edist) {Statistical::Distribution::Exponential.new(rate)}

    it 'mean is 1 / rate' do
      expect(edist.mean).to be_within(1e-12).of(1 / rate)
    end
  end

  describe '#variance' do
    let(:rate) {0.6}
    let(:edist) {Statistical::Distribution::Exponential.new(rate)}

    it 'variance is  1 / rate^2' do
      expect(edist.variance).to be_within(1e-12).of(1 / (rate * rate))
    end
  end

  describe '#==' do
    context 'when compared against another Uniform distribution' do
      let(:rate) {rand(10)}
      let(:edist) {Statistical::Distribution::Exponential.new}
      let(:edist_clone) {Statistical::Distribution::Exponential.new}
      let(:edist_alt) {Statistical::Distribution::Exponential.new(rate)}
      it 'returns `true` if they have the same parameters' do
        expect(edist == edist_clone).to be true
      end

      it 'returns `false` if they have different parameters' do
        expect(edist == edist_alt).to be false
      end
    end

    context 'when compared against any distribution type' do
      skip("Not implemented yet")
    end
  end
end
