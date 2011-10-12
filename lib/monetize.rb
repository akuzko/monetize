require "monetize/version"
require "monetize/money"
require "monetize/calculation_helper"

require 'yaml'
# in Ruby 1.9.2, Psych is replacement for YAML serialization. And have to
# integrate with it in a different way.
if defined? Psych
  require "monetize/psych"
else
  require "monetize/yaml"
end

module Monetize
  # Your code goes here...
end
