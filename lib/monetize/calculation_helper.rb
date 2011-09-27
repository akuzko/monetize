module Monetize
  # This module handles money conversions for a method calls. For example,
  # some class method may take money_obj = 1234.0 as a parameter, perform some
  # heavy calculations and then return result:
  #   def calculate(money_obj)
  #     months, rate = 36, 0.00375
  #     result = money_obj * rate
  #     result /= (1 - 1 / (1 + rate) ** months)
  #   end
  # Since there is no need to round result after each operations, and considering
  # the fact that final result should be Money object with 2 decimal digits after
  # the decimal point, this module helps to do it automatically for all methods
  # that have a name starting with 'calculate', as a convention
  module CalculationHelper
    def self.included base
      base.extend ClassMethods
      class << base
        extend ClassMethods
      end
    end
    
    module ClassMethods
      def method_added method_name
        return unless method_name.to_s =~ /^calculate/
        alias_name = "#{method_name}_without_money_helper"
        return if instance_methods.map(&:to_s).include?(alias_name) || method_name.to_s =~ /_without_money_helper$/
        alias_method alias_name, method_name
        define_method method_name do |*args, &block|
          Monetize::Money.calculations do
            send(alias_name, *args, &block)
          end
        end
      end
      
      def singleton_method_added method_name
        singleton = class << self; self; end
        singleton.instance_eval do
          ClassMethods.instance_method(:method_added).bind(self).call(method_name)
        end
      end
    end
  end
end