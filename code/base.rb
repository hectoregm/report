module Bezel
  class Base
    extend Bezel::Associations
    extend ActiveModel::Naming
    include Bezel::Connections
    include ActiveModel::Conversion

    class << self
      def config_option(name, default)
        singleton_class.instance_eval do
          define_method(name) do
            instance_variable_get(:"@#{name}") || default
          end

          attr_writer :"#{name}"
          alias_method :"set_#{name}", :"#{name}="
        end

        define_method(name) do
          self.class.send(name)
        end
      end

      def find(*arguments)
        # ...
      end

      def invoke(action, params)
        Bezel.invoke(c3_module, c3_type, action, params)
      end

      def inherited(klass)
        klass.config_option :c3_type, klass.model_name
        klass.config_option :c3_module, 'peat'
        klass.config_option :c3_include, nil
        klass.c3_cached(false)
      end

      attr_reader :cache_type

      def c3_cached(flag = :local, opts = {})
        if flag && Bezel.cache
          include Bezel::CacheBase
          @cache_type = flag
          @cache_opts = opts
        end
      end
      
      # ...
    end

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
        # Bezel.debug("Could not get '#{name}' returning null in #{caller(1)[0]}")
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

  class Base
    extend ActiveModel::Naming
    include Bezel::Connections
    include ActiveModel::Conversion
  end
end
