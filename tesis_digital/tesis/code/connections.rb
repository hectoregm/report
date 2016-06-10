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
      action = invoke(:upsert, obj: attrs)
      # ...
    end
  end

  def save
    # ...
    self.class.upsert(self.to_hash)
    # ...
  end

  def update(update)
    # ...
    action = self.class.invoke(:upsert, obj: update, srcObj: old)
    # ...
  end

  def destroy
    self.class.invoke(:remove, obj: self.to_hash)
  end
end
