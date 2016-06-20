require 'spec_helper'
require 'statistical/rng/gumbel'
require 'statistical/distribution/gumbel'

describe Statistical::Rng::Gumbel do
  describe '.new' do
    context 'when called with no arguments' do
      it 'has location = 0' do
        expect(Statistical::Rng::Gumbel.new.location).to eq(0)
      end

      it 'has scale = 1' do
        expect(Statistical::Rng::Gumbel.new.scale).to eq(1)
      end
    end

    context 'when parameters are specified' do
      let(:l)     {5 - 10 * rand}
      let(:s)     {rand}
      let(:gdist) {Statistical::Distribution::Gumbel.new(l, s)}
      let(:grng)  {Statistical::Rng::Gumbel.new(gdist)}

      it 'has the right location set' do
        expect(grng.location).to eq(l)
      end

      it 'has the right scale set' do
        expect(grng.scale).to eq(s)
      end
    end

    context 'when initialized with a seed' do
      let(:l)       {5 - 10 * rand}
      let(:s)       {rand}
      let(:seed)    {Random.new_seed}
      let(:gdist)   {Statistical::Distribution::Gumbel.new(l, s)}
      let(:grng_a)  {Statistical::Rng::Gumbel.new(gdist, seed)}
      let(:grng_b)  {Statistical::Rng::Gumbel.new(gdist, seed)}

      it 'should be repeatable for the same arguments' do
        expect(grng_a.rand).to eq(grng_b.rand)
      end
    end
  end

  describe '#rand' do
    it 'passes the G-test at a 95% significance level'
  end

  describe '#==' do
    context 'when compared against another Gumbel distribution' do
      let(:l)       {5 - 10 * rand}
      let(:s)       {rand}
      let(:seed_a)    {Random.new_seed}
      let(:seed_b)    {Random.new_seed}
      let(:gdist)   {Statistical::Distribution::Gumbel.new(l, s)}

      let(:grng_a)  {Statistical::Rng::Gumbel.new(gdist, seed_a)}
      let(:grng_b)  {Statistical::Rng::Gumbel.new(gdist, seed_b)}
      let(:grng_c)  {Statistical::Rng::Gumbel.new(gdist, seed_a)}

      it 'should return true if the arguments are the same' do
        expect(grng_a == grng_c).to be true
      end

      it 'should return false if arguments differ' do
        expect(grng_a == grng_b).to be false
      end
    end
  end
end

describe Statistical::Distribution::Gumbel do
  describe '.new' do
    context 'when called with no arguments' do
      it 'has location = 0' do
        expect(Statistical::Distribution::Gumbel.new.location).to eq(0)
      end

      it 'has scale = 1' do
        expect(Statistical::Distribution::Gumbel.new.scale).to eq(1)
      end
    end

    context 'when parameters are specified' do
      let(:l)     {5 - 10 * rand}
      let(:s)     {rand}
      let(:gdist) {Statistical::Distribution::Gumbel.new(l, s)}

      it 'has the correct location set' do
        expect(gdist.location).to eq(l)
      end

      it 'has the correct scale set' do
        expect(gdist.scale).to eq(s)
      end
    end
  end

  describe '#pdf' do
    context 'when called with x in the distribution\'s domain' do
      let(:l)     {5 - 10 * rand}
      let(:s)     {rand}
      let(:gdist) {Statistical::Distribution::Gumbel.new(l, s)}
      let(:x)     {l.abs * rand}

      it 'should evaluate the PDF correctly' do
        xs = (x - l) / s
        expect(gdist.pdf(x)).to be_within(Float::EPSILON).of(
          Math.exp(-xs - Math.exp(-xs)) / s
        )
      end
    end
  end

  describe '#cdf' do
    context 'when called with x in the distribution\'s domain' do
      let(:l)     {5 - 10 * rand}
      let(:s)     {rand}
      let(:gdist) {Statistical::Distribution::Gumbel.new(l, s)}
      let(:x)     {l.abs * rand}

      it 'should evaluate the CDF correctly' do
        xs = (x - l) / s
        expect(gdist.cdf(x)).to be_within(Float::EPSILON).of(
          Math.exp(-Math.exp(-xs))
        )
      end
    end
  end

  describe '#quantile' do
    context 'when called for x < 0' do
      let(:gdist) {Statistical::Distribution::Gumbel.new}
      it do
        expect {gdist.quantile(-Float::EPSILON)}.to raise_error(RangeError)
      end
    end

    context 'when called for x > 1' do
      let(:gdist) {Statistical::Distribution::Gumbel.new}
      it do
        expect {gdist.quantile(1 + Float::EPSILON)}.to raise_error(RangeError)
      end
    end

    context 'when called for x in [0, 1]' do
      let(:l)     {5 - 10 * rand}
      let(:s)     {rand}
      let(:gdist) {Statistical::Distribution::Gumbel.new(l, s)}
      let(:x)     {rand}

      it 'should return the correct quantile value' do
        expect(gdist.quantile(x)).to be_within(Float::EPSILON).of(
          l - s * Math.log(-Math.log(x))
        )
      end
    end
  end

  describe '#p_value' do
    let(:l)     {5 - 10 * rand}
    let(:s)     {rand}
    let(:gdist) {Statistical::Distribution::Gumbel.new}
    let(:x)     {rand}

    it 'should be the same as #quantile' do
      expect(gdist.quantile(x)).to eq(gdist.p_value(x))
    end
  end

  describe '#mean' do
    let(:l)     {5 - 10 * rand}
    let(:s)     {rand}
    let(:gdist) {Statistical::Distribution::Gumbel.new(l, s)}

    it 'should return the correct mean' do
      expect(gdist.mean).to be_within(Float::EPSILON).of(
        l + s * Statistical::EULER_GAMMA
      )
    end
  end

  describe '#variance' do
    let(:l)     {5 - 10 * rand}
    let(:s)     {rand}
    let(:gdist) {Statistical::Distribution::Gumbel.new(l, s)}

    it 'should return the correct variance' do
      expect(gdist.variance).to be_within(Float::EPSILON).of(
        ((Math::PI * s)**2) / 6
      )
    end
  end

  describe '#==' do
    context 'when compared against another Gumbel distribution' do
      let(:loc_a)       {5 - 10 * rand}
      let(:scl_a)       {rand}
      let(:loc_b)       {5 - 10 * rand}
      let(:scl_b)       {rand}

      let(:gdist_a)   {Statistical::Distribution::Gumbel.new(loc_a, scl_a)}
      let(:gdist_b)   {Statistical::Distribution::Gumbel.new(loc_b, scl_b)}
      let(:gdist_c)   {Statistical::Distribution::Gumbel.new(loc_a, scl_a)}

      it 'returns `true` if they have the same parameters' do
        expect(gdist_a == gdist_c).to be true
      end

      it 'returns `false` if they have different parameters' do
        expect(gdist_a == gdist_b).to be false
      end
    end
  end
end
