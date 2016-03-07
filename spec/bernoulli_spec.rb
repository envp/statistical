require 'spec_helper'
require 'statistical/rng/bernoulli'
require 'statistical/distribution/bernoulli'

describe Statistical::Rng::Bernoulli do
  it 'passes the G-test at a 95% significance level' do
  end

  describe '.new' do
    context 'when called with no arguments' do
      skip("FIXME")
    end

    context 'when parameters are specified' do
      skip("FIXME")
    end

    context 'when initialized with a seed' do
      it 'should be repeatable for the same arguments' do
        skip("FIXME")
      end
    end
  end

  describe '#rand' do
    it 'returns a number between 0 and 1 by default' do
      skip("FIXME")
    end

    it 'returns a bounded value when bounds are specified' do
      skip("FIXME")
    end
  end

  describe '#==' do
    context 'when compared against another uniform distribution' do
      it 'should return true if the bounds and seed are the same' do
        skip("FIXME")
      end

      it 'should return false if bounds / seed differ' do
        skip("FIXME")
      end
    end

    context 'when compared against any other distribution class' do
      it 'should return false if classes are different' do
        skip("FIXME")
      end
    end
  end
end


describe Statistical::Distribution::Bernoulli do
  describe '.new' do
    context 'when called with no arguments' do
      skip("FIXME")
    end
    
    context 'when upper and lower bounds are specified' do
      skip("FIXME")
    end
  end
  
  
  describe '#pdf' do
    context 'when called with x < lower_bound' do
      skip("FIXME")
    end
    
    context 'when called with x > upper_bound' do
      skip("FIXME")
    end
    
    context 'when called with x in [lower_bound, upper_bound]' do
      skip("FIXME")
    end
  end
  
  describe '#cdf' do
    context 'when called with x < lower' do
      skip("FIXME")
    end
    
    context 'when called with x > upper' do
      skip("FIXME")
    end
    
    context 'when called with x in [lower, upper]' do
      skip("FIXME")
    end
  end
  
  describe '#quantile' do
    context 'when called for x > 1' do
      skip("FIXME")
    end
    
    context 'when called for x < 0' do
      skip("FIXME")
    end
    
    context 'when called for x in [0, 1]' do
      skip("FIXME")
    end
  end
  
  describe '#p_value' do
    it 'should be the same as #quantile' do
      skip("FIXME")
    end
  end  
  
  describe '#mean' do
    it 'should return the correct mean' do
      skip("FIXME")
    end
  end
  
  describe '#variance' do
    it 'should return the correct variance' do
      skip("FIXME")
    end
  end
  
  describe '#==' do
    context 'when compared against another Uniform distribution' do
      it 'returns `true` if they have the same parameters' do
        skip("FIXME")
      end
      
      it 'returns `false` if they have different parameters' do
        skip("FIXME")
      end
    end
    
    context 'when compared against any distribution type' do
      skip("FIXME")
    end
  end
end