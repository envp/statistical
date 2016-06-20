require 'spec_helper'
require 'statistical/rng/frechet'
require 'statistical/distribution/frechet'

describe Statistical::Rng::Frechet do

  describe '.new' do
    context 'when called with no arguments' do
      it {
        expect {
          Statistical::Rng::Frechet.new
        }.to raise_error(ArgumentError)
      }
      
      context 'when called without a Statistical::Distribution::Frechet obj' do
        it {
          expect {
            Statistical::Rng::Frechet.new(Object.new)
          }.to raise_error(TypeError)
        }
      end
    end

    context 'when parameters are specified' do
      let(:alpha)    {rand}
      let(:scale)    {rand}
      let(:location) {rand}
      let(:fdist)    {Statistical::Distribution::Frechet.new(alpha, location, scale)}
      let(:frng)     {Statistical::Rng::Frechet.new(fdist)}

      it 'has the correct shape (alpha) parameter set' do
        expect(frng.alpha).to eq(alpha)
      end

      it 'has the correct location parameter set' do
        expect(frng.location).to eq(location)
      end

      it 'has the correct scale parameter set' do
        expect(frng.scale).to eq(scale)
      end
    end

    context 'when initialized with a seed' do
      let(:alpha) {rand}
      let(:fdist) {Statistical::Distribution::Frechet.new(alpha)}
      let(:seed) {Random.new_seed}
      let(:frng_a)  {Statistical::Rng::Frechet.new(fdist, seed)}
      let(:frng_b)  {Statistical::Rng::Frechet.new(fdist, seed)}

      it 'should be repeatable for the same arguments' do
        expect(frng_a.rand == frng_b.rand).to be true
      end
    end
  end

  describe '#rand' do
    it 'passes the G-test at a 95% significance level'
  end

  describe '#==' do
    context 'when compared against another Frechet distribution' do
      let(:alpha)   {rand}
      let(:loc_b)   {rand}
      let(:scl_b)   {rand}
      let(:seed_a)  {Random.new_seed}
      let(:seed_b)  {Random.new_seed}

      let(:fdist_a) {Statistical::Distribution::Frechet.new(alpha)}
      let(:fdist_b) {Statistical::Distribution::Frechet.new(alpha, loc_b, scl_b)}

      let(:frng_a)  {Statistical::Rng::Frechet.new(fdist_a, seed_a)}
      let(:frng_b)  {Statistical::Rng::Frechet.new(fdist_b, seed_b)}
      let(:frng_c)  {Statistical::Rng::Frechet.new(fdist_a, seed_a)}

      it 'should return true if the parameters are the same' do
        expect(frng_a == frng_c).to be true
      end

      it 'should return false if parameters differ' do
        expect(frng_a == frng_b).to be false
      end
    end
  end
end


describe Statistical::Distribution::Frechet do
  describe '.new' do
    context 'when called with no arguments' do
      it {
        expect {
          Statistical::Distribution::Frechet.new
        }.to raise_error(ArgumentError)
      }
    end

    context 'when parameters are specified' do
      let(:alpha) {rand}
      let(:loc)   {rand}
      let(:scale) {rand}
      let(:fdist) {Statistical::Distribution::Frechet.new(alpha, loc, scale)}

      it 'has the right alpha set' do
        expect(fdist.alpha).to eq(alpha)
      end

      it 'has the right location set' do
        expect(fdist.location).to eq(loc)
      end

      it 'has the right scale set' do
        expect(fdist.scale).to eq(scale)
      end
    end
  end

  describe '#pdf' do
    context 'when called with x < location parameter' do
      let(:alpha) {rand}
      let(:loc)   {rand}
      let(:scale) {rand}
      let(:fdist) {Statistical::Distribution::Frechet.new(alpha, loc, scale)}

      it {expect(fdist.pdf(loc - Float::EPSILON)).to eq(0)}
    end

    context 'when called with x in the distribution\'s domain' do
      let(:alpha) {rand}
      let(:l)     {rand}
      let(:s)     {rand}
      let(:fdist) {Statistical::Distribution::Frechet.new(alpha, l, s)}
      let(:x)     {l * (1 + rand)}

      it 'should evaluate the pdf correctly' do
        expect(fdist.pdf(x)).to be_within(Float::EPSILON).of(
          (alpha / s) *
          (((x - l) / s)**(-1 - alpha)) *
          Math.exp(-(((x - l) / s)**(-alpha)))
        )
      end
    end
  end

  describe '#cdf' do
    context 'when called with x < location parameter' do
      let(:alpha) {rand}
      let(:l)   {rand}
      let(:s) {rand}
      let(:fdist) {Statistical::Distribution::Frechet.new(alpha, l, s)}

      it {expect(fdist.cdf(l - Float::EPSILON)).to eq(0)}
    end

    context 'when called with x in the distribution\'s domain' do
      let(:alpha) {rand}
      let(:l)     {rand}
      let(:s)     {rand}
      let(:fdist) {Statistical::Distribution::Frechet.new(alpha, l, s)}
      let(:x)     {l * (1 + rand)}

      it 'should evaluate the cdf correctly' do
        expect(fdist.cdf(x)).to be_within(Float::EPSILON).of(
          Math.exp(-((x - l) / s)**(-alpha))
        )
      end
    end
  end

  describe '#quantile' do
    context 'when called for x < 0' do
      let(:fdist) {Statistical::Distribution::Frechet.new(1 + rand)}
      it {
        expect {
          fdist.quantile(-Float::EPSILON)
        }.to raise_error(RangeError)
      }
    end

    context 'when called for x > 1' do
      let(:fdist) {Statistical::Distribution::Frechet.new(1 + rand)}
      it {
        expect {
          fdist.quantile(1 + Float::EPSILON)
        }.to raise_error(RangeError)
      }
    end

    context 'when called for x in [0, 1]' do
      let(:alpha) {1 + rand}
      let(:l)     {rand}
      let(:s)     {rand}
      let(:fdist) {Statistical::Distribution::Frechet.new(alpha, l, s)}
      let(:x)     {rand}
      it 'should return the correct inverse CDF' do
        expect(fdist.quantile(x)).to be_within(Float::EPSILON).of(
          l + s * (-Math.log(x))**(-1 / alpha)
        )
      end
    end
  end

  describe '#p_value' do
    let(:alpha) {rand}
    let(:loc)   {rand}
    let(:scale) {rand}
    let(:fdist) {Statistical::Distribution::Frechet.new(alpha, loc,scale)}
    let(:x)     {rand}

    it 'should be the same as #quantile' do
      expect(fdist.quantile(x)).to eq(fdist.p_value(x))
    end
  end

  describe '#mean' do
    let(:alpha_1)     {rand}
    let(:alpha_2)     {1 + rand}
    let(:loc)         {rand}
    let(:scale)       {rand}
    let(:fdist)       {Statistical::Distribution::Frechet.new(alpha_2, loc, scale)}
    let(:fdist_m_inf) {Statistical::Distribution::Frechet.new(alpha_1, loc, scale)}

    it 'should return the correct mean' do
      expect(fdist.mean).to be_within(Float::EPSILON).of(
        loc + scale * Math.gamma(1 - 1 / alpha_2)
      )
    end

    it 'mean = Infinity for alpha < 1' do
      expect(fdist_m_inf.mean).to eq(Float::INFINITY)
    end
  end

  describe '#variance' do
    let(:alpha_1)     {2 * rand}
    let(:alpha_2)     {2 + rand}
    let(:loc)         {rand}
    let(:s)           {rand}
    let(:fdist)       {Statistical::Distribution::Frechet.new(alpha_2, loc, s)}
    let(:fdist_v_inf) {Statistical::Distribution::Frechet.new(alpha_1, loc, s)}

    it 'should return the correct variance' do
      expect(fdist.variance).to be_within(Float::EPSILON).of(
        s * s * (
          Math.gamma(1 - 2 / alpha_2) -
          Math.gamma(1 - 1 / alpha_2)**2
        )
      )
    end

    it 'variance = Infinity for alpha =< 2' do
      expect(fdist_v_inf.variance).to eq(Float::INFINITY)
    end
  end

  describe '#==' do
    context 'when compared against another Uniform distribution' do
      let(:alpha)   {rand}
      let(:loc_b)   {rand}
      let(:scl_b)   {rand}

      let(:fdist_a) {Statistical::Distribution::Frechet.new(alpha)}
      let(:fdist_b) {Statistical::Distribution::Frechet.new(alpha, loc_b, scl_b)}
      let(:fdist_c) {Statistical::Distribution::Frechet.new(alpha)}
      
      it 'returns `true` if they have the same parameters' do
        expect(fdist_a == fdist_c).to be true
      end
      
      it 'returns `false` if they have different parameters' do
        expect(fdist_a == fdist_b).to be false
      end
    end
  end
end