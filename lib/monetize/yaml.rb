require 'yaml'

class Monetize::Money
  yaml_as 'tag:tmxcredit.com,2011:money'
  
  def to_yaml opts = {}
    YAML.quick_emit(nil, opts) do |out|
      out.scalar("tag:tmxcredit.com,2011:money", self.inspect, :plain)
    end
  end
end

YAML.add_domain_type("tmxcredit.com,2011", "money") do |type, val|
  Monetize::Money.new val
end
