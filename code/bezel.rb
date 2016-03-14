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
      o_tenant = Bezel.client.tenant
      o_tag = Bezel.client.tag
      o_auth_token = Bezel.client.auth_token
      Bezel.client.tenant = tenant
      Bezel.client.tag = tag
      Bezel.client.auth_token = auth_token
      yield
    ensure
      Bezel.client.tenant = o_tenant
      Bezel.client.tag = o_tag
      Bezel.client.auth_token = o_auth_token
    end
  end

  # ...
  
end