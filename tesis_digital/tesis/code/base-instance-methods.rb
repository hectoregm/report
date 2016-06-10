module Bezel
  class Base

    # ...

    attr_accessor :errors

    def initialize(attributes = Hashie::Mash.new, 
                   persisted = false)
      # ...
      load(attributes)
    end
    
    def load(attributes)
      # ...
    end
    
    def method_missing(name, *args, &block)
      if args.empty?
        original_name = name.to_s
        return @attributes[original_name] if @attributes.key?(original_name)
        camelized_name = name.to_s.camelize(:lower)
        return @attributes[camelized_name] if @attributes.key?(camelized_name)
        return nil
      end
      super
    end
    
    def id
      @attributes["id"]
    end

    # ...

  end
end