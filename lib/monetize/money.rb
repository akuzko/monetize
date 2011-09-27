require 'delegate'

module Monetize
  # Money class is designed to handle money representation of a value.
  # For the most, it acts like a float, but can only have 2 digits after
  # the decimal point, reprsenting cents.
  # Also, it handles special money behavior and rounding options.
  class Money < DelegateClass ::Float
    # This Exception supposed to be raised whenever incorrect action is performed
    # upon money object. For example, money cannot be multiplied by any other money
    class InvalidValue < ArgumentError
      def initialize type
        message = case type
        when :multiplication then "Money cannot be multiplied by Money"
        when :power then "Money cannot be raised in any power"
        end
        super message
      end
    end
    
    # rounds passed value using the most basic rounding method
    # @param [Float] value to be rounded
    def self.round value
      return value if disabled?
      (value * 100).round / 100.0
    end
    
    # disables rounding for the Money objects for the duration of block
    def self.without_rounding
      disable_rounding!
      yield
    ensure
      enable_rounding!
    end
    
    # This method disables roundings for money objects for a duration of block.
    # And then tries to returs rounded value
    def self.calculations
      result = without_rounding{ yield }
      round_result result
    end
    
    # Disables rounding for Money objects
    def self.disable_rounding!
      @rounding_disabled = true
    end
    private_class_method :disable_rounding!
    
    # Enables rounding for Money objects
    def self.enable_rounding!
      @rounding_disabled = false
    end
    private_class_method :enable_rounding!
    
    # Specifies if rounding has been disabled
    # Always returns boolean value
    def self.disabled?
      !!@rounding_disabled
    end
    private_class_method :disabled?
    
    # Converts passed object to a Money object if it is a Float
    # or changes all Float instance_variables to a Money objects
    # @param [Mixed] object to be monetized
    # @param [Symbol] rounding to use
    def self.round_result obj
      if obj.is_a? Money
        obj.round!
      elsif obj.respond_to? :instance_variables
        obj.instance_variables.each do |var_name|
          round_result(obj.instance_variable_get(var_name))
        end
      end
      return obj
    end
    private_class_method :round_result
    
    def initialize obj
      float = obj.to_f
      super(Money.round(float))
      @dc_name = instance_variables.first
    end
    
    # defining standart operators to return Money objects
    %w(+ -).each do |operator|
      define_method operator do |other|
        Money.new(super(other))
      end
    end
    
    # devides money object by another object
    # returns float if other is Money, or Money object otherwise
    def / other
      Money === other ? (dc_obj / ~other) : Money.new(super(other))
    end
    
    # multiplies money by a scalar. raises exception if Money object is passed
    def * other
      raise InvalidValue.new(:multiplication) if other.is_a? Money
      Money.new super(other)
    end
    
    # raises exception, since money cannot be multiplied by money
    def ** power
      raise InvalidValue.new(:power)
    end
    
    # returns original Float value
    def ~@
      dc_obj
    end
    
    # rounds internal float representation to second decimal digit (cents)
    def round!
      self.dc_obj = Money.round dc_obj
    end
    
    def dc_obj
      instance_variable_get(@dc_name)
    end
    private :dc_obj
    
    def dc_obj= val
      instance_variable_set(@dc_name, val)
    end
    private :dc_obj=
  end
end