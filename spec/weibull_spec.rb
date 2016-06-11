require 'spec_helper'
require 'statistical/rng/weibull'
require 'statistical/distribution/weibull'

describe Statistical::Rng::Weibull do
  it 'passes the G-test at a 95% significance level' do
  end

  describe '.new' do
    context 'when called with no arguments' do
      it 'should have scale = 1'
      it 'should have shape = 1'
    end

    context 'when parameters are specified' do
      it 'should have the correct scale parameter set'
      it 'should have the correct shape parameter set'
    end

    context 'when initialized with a seed' do
      it 'should be repeatable for the same arguments'
    end
  end

  describe '#rand' do
    it 'returns a non-negative number'
  end

  describe '#==' do
    context 'when compared against another uniform distribution' do
      it 'should return true if the bounds and seed are the same'
      it 'should return false if bounds / seed differ'
    end

    context 'when compared against any other distribution class' do
      it 'should return false if classes are different'
    end
  end
end


describe Statistical::Distribution::Weibull do
  describe '.new' do
    context 'when called with no arguments' do
      it 'should have scale = 1'
      it 'should have shape = 1'
    end
    
    context 'when upper and lower bounds are specified' do
      it 'should have the correct scale parameter set'
      it 'should have the correct shape parameter set'
    end
  end
  
  
  describe '#pdf' do
    context 'when called with x < lower_bound' do
      it {}
    end
    
    context 'when called with x > upper_bound' do
      it {}
    end
    
    context 'when called with x in [lower_bound, upper_bound]' do
      it 'returns a value consistent with the weibull PDF'
    end
  end
  
  describe '#cdf' do
    context 'when called with x < lower' do
      it {}
    end
    
    context 'when called with x > upper' do
      it {}
    end
    
    context 'when called with x in [lower, upper]' do
      it 'returns a value consistent with the weibull PMF'
    end
  end
  
  describe '#quantile' do
    context 'when called for x > 1' do
      it {}
    end
    
    context 'when called for x < 0' do
      it {}
    end
    
    context 'when called for x in [0, 1]' do
      it {}
    end
  end
  
  describe '#p_value' do
    it 'should be the same as #quantile'
  end  
  
  describe '#mean' do
    it 'should return the correct mean'
  end
  
  describe '#variance' do
    it 'should return the correct variance'
  end
  
  describe '#==' do
    context 'when compared against another Uniform distribution' do
      it 'returns `true` if they have the same parameters'
      it 'returns `false` if they have different parameters'
    end
    
    context 'when compared against any distribution type' do
      it 'returns false'
    end
  end
end