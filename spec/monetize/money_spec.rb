require 'spec_helper'

describe Monetize::Money do
  context "instance functionality" do
    let(:money){ Monetize::Money.new 12.34 }
    
    it "should add float value as a money" do
      (money + 1.23).should be_instance_of(Monetize::Money)
    end
    
    it "should substract float value as a money" do
      (money - 1.23).should be_instance_of(Monetize::Money)
    end
    
    it "should be devisable and return money" do
      (money / 5).should be_instance_of(Monetize::Money)
    end
    
    it "should return numeric when devided by money" do
      (money / money).should_not be_instance_of(Monetize::Money)
    end
    
    it "should be multiplyeble by number and result should be money" do
      (money * 2.2).should be_instance_of(Monetize::Money)
    end
    
    it "should raise exception when multiplying money by money" do
      expect{ money * money }.to raise_error Monetize::Money::InvalidValue
    end
    
    it "should raise exception when raising money to power" do
      expect{ money ** 3 }.to raise_error Monetize::Money::InvalidValue
    end
    
    it "should be YAML serializable" do
      yaml = money.to_yml
      yaml_money = YAML.load yaml
      yaml_money.should be_instance_of Monetize::Money
      yaml_money.should == money
    end
  end
  
  context "class methods" do
    def money val
      Monetize::Money.new val
    end
    
    it "should round values for money" do
      money(100.0 / 3).should == 33.33
    end
    
    it "should round values properly " do
      money(12.344).should == 12.34
      money(12.345).should == 12.35
      money(12.346).should == 12.35
    end
    
    it "should not round money objects inside calculations block, but return rounded value" do
      mon = money(100.00)
      mon = Monetize::Money.calculations do
        mon /= 3
        mon.should_not == 33.33
        mon * 2
      end
      mon.should == 66.67
    end
  end
end
