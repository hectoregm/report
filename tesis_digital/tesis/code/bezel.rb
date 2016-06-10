module Bezel
  extend Config

  class << self
    def new(options={})
      Bezel::Client.new(options)
    end

    def invoke(*args)
      client.invoke(*args)
    end

    def client
      @@client ||= Bezel::Client.new()
    end

    def context(tenant, tag, auth_token = nil)
      # ...
    end
  end
end