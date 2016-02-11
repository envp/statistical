require 'spec_helper'
require 'statistical/rng/uniform'

describe Statistical::Rng::Uniform do
  # `.new` will be tested by explicitly calling the constructor for
  # `Statistical::Rng::Uniform`, as the Rng factory module (`Statistical::Rng`)
  # and it's concenrs are tested elsewhere. The same applies for the others

  it 'passes the G-test at a 95% significance level' do
    skip('Need to find a good library that supports this')
  end

  describe '.new' do
    context 'when called with no arguments' do
      let(:obs) { Statistical::Rng::Uniform.new }

      it 'returned instance has attribute lower = 0.0' do
        expect(obs.lower).to eq(0.0)
      end

      it 'returned instance has attribute upper = 1.0' do
        expect(obs.upper).to eq(1.0)
      end
    end

    context 'when upper and lower bounds are specified' do
      let(:lo) { 12 }
      let(:up) { 16 }
      let(:obs) { Statistical::Rng::Uniform.new(Random.new_seed, lo, up) }

      it 'has the right lower bound attribute' do
        expect(obs.lower).to eq(lo)
      end

      it 'has the right upper bound attribute' do
        expect(obs.upper).to eq(up)
      end
    end

    context 'when initialized with a seed' do
      let(:seed) { Random.new_seed }
      let(:gen_a) { Statistical::Rng::Uniform.new(seed) }
      let(:gen_b) { Statistical::Rng::Uniform.new(seed) }

      it 'should be equivalent if the same seed is used' do
        expect(gen_a).to eq(gen_b)
      end
    end
  end

  describe '#rand' do
    let(:obs_default) { Statistical::Rng::Uniform.new }
    let(:lo) { 12 }
    let(:up) { 16 }
    let(:obs) { Statistical::Rng::Uniform.new(Random.new_seed, lo, up) }

    it 'returns a number between 0 and 1 by default' do
      sample = obs_default.rand
      expect(sample).to be <= 1
      expect(sample).to be >= 0
    end

    it 'returns a bounded value when bounds are specified' do
      sample = obs.rand
      expect(sample).to be <= 16
      expect(sample).to be >= 12
    end
  end

  describe '#eql?' do
    context 'when compared against another uniform distribution' do
      let(:seed_a) { Random.new_seed }
      let(:seed_b) { Random.new_seed }
      let(:gen_a) { Statistical::Rng::Uniform.new(seed_a) }
      let(:gen_a_cp) { Statistical::Rng::Uniform.new(seed_a) }
      let(:gen_b) { Statistical::Rng::Uniform.new(seed_a, 1, 2) }

      it 'should return true if the bounds and seed are the same' do
        expect(gen_a).to eq(gen_a_cp)
      end

      it 'should return false if bounds / seed differ' do
        expect(gen_a).not_to eq(gen_b)
      end
    end

    context 'when compared against any other distribution class' do
      it 'should return false if classes are different' do
        skip('Waiting for other rngs for a complete test suite')
      end
    end
  end
end
