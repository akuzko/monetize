class Monetize::Money
  yaml_as 'tag:tmxcredit.com,2011:money'
  
  def self.allocate
    new 0
  end
  
  def init_with coder
    self.dc_obj = coder.scalar.to_f
  end
  
  def encode_with coder
    coder.scalar = dc_obj.to_s
  end
  
  def to_yml
    Psych.dump(self)
  end
end
