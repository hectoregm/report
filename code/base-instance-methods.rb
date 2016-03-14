module Bezel
  class Base

    # ...

    attr_accessor :errors

    def initialize(attributes = Hashie::Mash.new, persisted = false)
      @persisted = persisted
      @errors = ActiveModel::Errors.new(self)
      load(attributes)
    end
    
    def associations
      self.class.associations if self.class.respond_to?(:associations)
    end

    def load(attributes)
      raise ArgumentError, "expected an attributes Hash, recieved #{attributes.class} #{attributes.inspect}" unless attributes.is_a?(Hash)

      @attributes = attributes.dup
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

    def to_param
      @attributes["id"]
    end

    def valid?
      true
    end

    # ...

  end
end