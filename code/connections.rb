module Bezel::Connections
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def all(params = {})
      params[:include] ||= c3_include if c3_include
      action = invoke(:fetch, spec: params)

      if action.result["count"] == 0 || action.result["objs"].nil?
        []
      else
        action.result["objs"].map {|o| new(o) }
      end
    end

    def one(params = {})
      # ...
      action = invoke(:fetch, spec: params)
      # ...
    end

    def upsert(attrs)
      # ...
      action = invoke(:upsert, obj: result)
      # ...
    end

    def upsert_batch(batch)
      # ...
    end
  end

  def save
    self.class.invoke(:upsert, obj: self.to_hash)
  end

  def update(attrs)
    # ...

    action = self.class.invoke(:upsert, obj: updated, srcObj: old)

    # ...
  end

  alias_method :update_attributes, :update

  def destroy
    self.class.invoke(:remove, obj: self.to_hash(with_associations: false))
  end
end
