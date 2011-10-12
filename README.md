#Monetize

Ruby helper module for dealing with money-like objects (represented as
floats with exactly two digits after decimal point for cents).

Also provides calculations helper to disable money rounding during calculations.

##Example

```ruby
    money = Monetize::Money.new(100) # => 100.0
    money /= 3 # => 33.33
    money * money # => will raise exception since money squared is meaningless
    money *= 3 # => 99.99
    
    # rounding can be disabled for a duration of code:
    Monetize::Money.without_rounding do
      money = Monetize::Money.new(100)
      money /= 3
      money *= 3
    end
    # will result in 100.0
    
    # Since disabling rounding may be usefull for calculations, Monetize
    # provides CalculationHelper helper that wraps 'calculate*' named
    # methods to disable rounding for the duration of method call:
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
      
      def calculate
        months, rate = 36, 0.00375
        result = @amount * rate
        result / (1 - 1 / (1 + rate) ** months)
      end
    end
    # without disabled rounding, provided methods will return 36.73 instead of 36.71 
    Payment.calculate(Monetize::Money.new(1234.0)) # => 36.71
    Payment.new(1234.0).calculate # => 36.71
    
    # Monetize::Money also provides yaml serialization for both YAML and Psych
    money = Monetize::Money.new(12.34)
    money.to_yml
```

##Copyright

Copyright (c) 2011 TMX Credit, released under the MIT license
