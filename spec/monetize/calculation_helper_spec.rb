require 'spec_helper'

describe Monetize::CalculationHelper do
  class Payment
    attr_accessor :amount
    
    include Monetize::CalculationHelper
    
    def initialize amount
      @amount = Monetize::Money.new amount
    end
    
    def self.calculate amount
      months, rate = 36, 0.00375
      result = amount * rate
      result /= (1 - 1 / (1 + rate) ** months)
    end
    
    def self.calculate_and_create amount
      months, rate = 36, 0.00375
      result = amount * rate
      result /= (1 - 1 / (1 + rate) ** months)
      self.new result
    end
    
    def calculate
      months, rate = 36, 0.00375
      result = @amount * rate
      result / (1 - 1 / (1 + rate) ** months)
    end
  end
  
  let(:payment){ Payment.new 1234.0 }
  
  # without disabled rounding, provided methods will return
  # 36.73 instead of 36.71 
  it "instance methods should return money objects" do
    payment.calculate.should be_instance_of Monetize::Money
    payment.calculate.should == 36.71
  end
  
  it "class methods should return money object" do
    Payment.calculate(Monetize::Money.new(1234.0)).should be_instance_of Monetize::Money
    Payment.calculate(Monetize::Money.new(1234.0)).should == 36.71
  end
  
  it "class methods should return objects with money as instance_variables" do
    Payment.calculate_and_create(1234.0).amount.should be_instance_of Monetize::Money
    Payment.calculate_and_create(1234.0).amount.should == 36.71
  end
end