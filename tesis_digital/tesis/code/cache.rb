class Bezel::Cache
  def initialize(config = {local: true, shared: true})
    @caches = {}
    [:local, :shared].each do |t|
      @caches[t] = if (cache_config = config[t]) && cache_config.respond_to?(:"[]")
        if /Cassandra/ =~ cache_config[:class]
          require 'bezel/moneta/cassandra'
        end
        cache_config[:class].constantize.new(cache_config[:options] || {})
      else
        ::Moneta::Adapters::Memory.new
      end
    end
  end

  attr_reader :caches

  def read(key, type = :local)
    @caches[type][key]
  end

  def write(key, value, type = :local, opts = {})
    @caches[type].store(key, value, opts)
  end

  def remove_id(key, id, type = :local)
    # ...
  end

  def delete(spec_or_id, type = :local)
    # ...
  end

  def update(id, new_value, type = :local, opts = {})
    # ...
  end
end
