module Bezel::CacheBase
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :memo

    if Bezel.cache && !Bezel.cache.class == Bezel::Cache
      Bezel.cache = Bezel::Cache.new
    end

    def prime
      all
    end

    def cache_read(key)
      Bezel.cache.read(key_for(key), @cache_type)
    end

    def cache_write(key, value)
      Bezel.cache.write(key_for(key), value, @cache_type, @cache_opts)
    end

    def cache_delete(spec_or_id)
      Bezel.cache.delete(key_for(spec_or_id), @cache_type)
    end

    def all(params = {})
      params[:include] = c3_include if c3_include
      tmp = cache_read(params)

      if tmp
        tmp.map {|id| one(id)}
      else
        records = super
        cache_write(params, records.map {|r| r.id})
        records.each do |record|
          cache_write(record.id, record.to_hash(with_associations: false))
        end
        records
      end
    end

    def one(params = {})
      # ...
    end

    def key_for(id_or_key, scoped = false)
      if @cache_type == :local
        prefix = "#{Bezel.tenant}-#{Bezel.tag}-#{model_name}"
      else
        prefix = "#{Bezel.tenant}-#{Bezel.tag}-#{model_name}-#{Bezel.client.auth_token}"
      end

      if id_or_key.respond_to?(:to_hash) || scoped
        id_or_key[:include] = c3_include if c3_include
        "#{prefix}|all(#{id_or_key})"
      else
        "#{prefix}|#{id_or_key}"
      end
    end
  end

  def save
    # ...
  end

  def update(attrs)
    a = super
    cache_delete(self.id)
  end

  def destroy
    # ...
  end
end
