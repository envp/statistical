require 'spec_helper'
require 'statistical/rng/two_point'
require 'statistical/distribution/two_point'

describe Statistical::Rng::Bernoulli do
  it 'passes the G-test at a 95% significance level' do
    skip('FIXME: Not implemented yet')
  end

  describe '.new' do
    let(:st_loss) {10}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}
    let(:seed) {Random.new_seed}
    let(:seed_clone) {seed}
    let(:trng) {Statistical::Rng::TwoPoint.new}
    let(:trng_prm) {Statistical::Rng::TwoPoint.new(tdist, seed)}
    let(:trng_prm_clone) {Statistical::Rng::TwoPoint.new(tdist, seed_clone)}

    context 'when called with no arguments' do
      it 'probability of success is 0.5' do
        expect(trng.p).to eq(0.5)
      end

      it 'has support set defined as: [0,1]' do
        expect(trng.support).to eq([0, 1])
      end
    end

    context 'when parameters are specified' do
      it 'probability of success is 0.5' do
        expect(trng_prm.p).to eq(prob)
      end

      it 'has support set defined as: [0,1]' do
        expect(trng_prm.support).to eq([st_loss, st_win])
      end
    end

    context 'when initialized with a seed' do
      it 'should be repeatable for the same arguments' do
        expect(trng_prm).to eq(trng_prm_clone)
      end
    end
  end

  describe '#rand' do
    let(:st_loss) {10}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}
    let(:seed) {Random.new_seed}
    let(:trng) {Statistical::Rng::TwoPoint.new(tdist, seed)}

    it 'returns an element from the support set' do
      expect([st_loss, st_win]).to include(trng.rand)
    end
  end

  describe '#==' do
    let(:st_loss) {10}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}
    let(:seed) {Random.new_seed}
    let(:seed_clone) {seed}
    let(:seed_b) {Random.new_seed}
    let(:trng) {Statistical::Rng::TwoPoint.new(tdist, seed)}
    let(:trng_b) {Statistical::Rng::TwoPoint.new(tdist, seed_b)}
    let(:trng_clone) {Statistical::Rng::TwoPoint.new(tdist, seed_clone)}

    context 'when compared against another uniform distribution' do
      it 'should return true if the parameters and seed are the same' do
        expect(trng).to eq(trng_clone)
      end

      it 'should return false if parameters / seed differ' do
        expect(trng).not_to eq(trng_b)
      end
    end

    context 'when compared against any other distribution class' do
      it 'should return false if classes are different' do
        skip
      end
    end
  end
end

describe Statistical::Distribution::Bernoulli do
  describe '.new' do
    context 'when called with no arguments' do
      let(:tdist) {Statistical::Distribution::TwoPoint.new}
      it 'should have possible states as (0, 1)' do
        expect(tdist.states.values).to eq([0, 1])
      end

      it 'should have probability of success = 0.5' do
        expect(tdist.p).to eq(0.5)
      end
    end

    context 'when parameters are specified' do
      let(:st_loss) {10}
      let(:st_win) {15}
      let(:prob) {0.6}

      context 'when indistinct states are given' do
        it do
          expect do
            Statistical::Distribution::TwoPoint.new(prob, st_win, st_win)
          end.to raise_error(ArgumentError)
        end
      end

      context 'when failure > success' do
        it do
          expect do
            Statistical::Distribution::TwoPoint.new(prob, st_win, st_loss)
          end.to raise_error(ArgumentError)
        end
      end

      context 'when states are not Numeric' do
        it do
          expect do
            Statistical::Distribution::TwoPoint.new(prob, st_win.to_s, st_loss)
          end.to raise_error(ArgumentError)
        end
      end

      context 'when improper probability is given' do
        it do
          expect do
            Statistical::Distribution::TwoPoint.new(1 / prob, st_loss, st_win)
          end.to raise_error(ArgumentError)
        end
      end

      context 'when parameters are specified correctly' do
        let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}
        it 'has the correct probability set' do
          expect(tdist.p).to eq(prob)
        end

        it 'has the correct states set' do
          expect(tdist.states.values).to eq([st_loss, st_win])
        end
      end
    end
  end

  describe '#pdf' do
    context 'when called with x that is not an accepted state' do
      let(:st_loss) {10}
      let(:st_win) {15}
      let(:prob) {0.6}
      let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

      it {expect(tdist.pdf(st_loss - 1)).to eq(0)}
    end

    context 'when called with x that is an accepted state' do
      let(:st_loss) {10}
      let(:st_win) {15}
      let(:prob) {0.6}
      let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

      it {expect(tdist.pdf(st_loss)).to eq(1 - prob)}
    end
  end

  describe '#cdf' do
    context 'when called with x < lower bound' do
      let(:st_loss) {10}
      let(:st_win) {15}
      let(:prob) {0.6}
      let(:delta) {1e-6}
      let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

      it {expect(tdist.cdf(st_loss - delta)).to eq(0)}
    end

    context 'when called with x > upper bound' do
      let(:st_loss) {10}
      let(:st_win) {15}
      let(:prob) {0.6}
      let(:delta) {1e-6}
      let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

      it {expect(tdist.cdf(st_win + delta)).to eq(1)}
    end

    context 'when called with x in [lower, upper]' do
      let(:st_loss) {10}
      let(:st_win) {15}
      let(:prob) {0.6}
      let(:delta) {1e-6}
      let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

      it 'should output the correct value' do
        x = st_loss + rand * (st_win - st_loss)
        expect(tdist.cdf(x)).to eq(1 - prob)
      end
    end
  end

  describe '#quantile' do
    let(:st_loss) {10}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:delta) {1e-6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

    context 'when called for x > 1' do
      it do
        expect do
          tdist.quantile(1 + delta)
        end.to raise_error(RangeError)
      end
    end

    context 'when called for x < 0' do
      it do
        expect do
          tdist.quantile(0 - delta)
        end.to raise_error(RangeError)
      end
    end

    context 'when called for x in [0, 1]' do
      it 'returns failure state for x below failure probability' do
        expect(tdist.quantile(1 - prob - delta)).to eq(st_loss)
      end

      it 'returns success state for x at or above failure probability' do
        expect(tdist.quantile(1 - prob + delta)).to eq(st_win)
      end
    end
  end

  describe '#p_value' do
    let(:st_loss) {10}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}
    it 'should be the same as #quantile' do
      x = rand
      expect(tdist.p_value(x)).to eq(tdist.quantile(x))
    end
  end

  describe '#mean' do
    let(:st_loss) {10}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

    it 'should return the correct mean' do
      expect(tdist.mean).to eq(st_loss + prob * (st_win - st_loss))
    end
  end

  describe '#variance' do
    let(:st_loss) {10}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}

    it 'should return the correct variance' do
      evar = ((1 - prob) * (st_loss**2) + prob * (st_win**2)) - (tdist.mean**2)
      expect(tdist.variance).to eq(evar)
    end
  end

  describe '#==' do
    let(:st_loss) {10}
    let(:st_loss_b) {11}
    let(:st_win) {15}
    let(:prob) {0.6}
    let(:tdist) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}
    let(:tdist_clone) {Statistical::Distribution::TwoPoint.new(prob, st_loss, st_win)}
    let(:tdist_b) {Statistical::Distribution::TwoPoint.new(prob, st_loss_b, st_win)}

    context 'when compared against another TwoPoint distribution' do
      it 'returns `true` if they have the same parameters' do
        expect(tdist).to eq(tdist_clone)
      end

      it 'returns `false` if they have different parameters' do
        expect(tdist).not_to eq(tdist_b)
      end
    end

    context 'when compared against any distribution type' do
      skip
    end
  end
end
