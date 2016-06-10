module Boolean
  def boolean?
    true
  end

  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.empty? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

module RandomString
  def random
    (0...8).map { (65 + rand(26)).chr }.join
  end
end

class String
  include Boolean
  extend RandomString
end

puts "no".to_bool     # false
puts "false".boolean? # true
puts String.random    # cadena aleatoria de tamaño 8