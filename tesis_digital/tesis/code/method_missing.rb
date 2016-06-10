object = Object.new #<Object:0x007f93d9a4e498>
o.bad_method
# Lanza errorNoMethodError: undefined method `bad_method' for
# <Object:0x007f93d9a4e498>

class << o
  def method_missing(name, *args)
    puts "Bad method"
  end
end

o.bad_method # Imprime 'Bad method'