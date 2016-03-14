module Bezel
  class Base
    # ...
    
    class << self     
      attr_reader :cache_type
      
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

      def c3_cached(flag = :local, opts = {})
        if flag && Bezel.cache
          include Bezel::CacheBase
          @cache_type = flag
          @cache_opts = opts
        end
      end
    end
    
    # ...
  end
end