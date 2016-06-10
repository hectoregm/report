module Bezel
  class Client
    include Config

    # ...

    def conn
      @conn ||= Faraday.new(url: @base_uri) do |faraday|
        # Configuracion cliente HTTP
      end
    end

    def invoke(mod, typ, action_name, params={})
      target = Target.new(@tenant, @tag, mod, typ)
      action = Bezel::Action.new(target, action_name, params)

      endpoint = "/api/#{@api_version}/#{target.tenant}/#{target.module};#{target.tag}/#{target.type}?action=#{action_name}"
      body = JSON.generate(params)

      # ...

      opts = {
        :headers => {
          "content-type" => "application/json",
          "user-agent" => "ruby-bezel",
          "Accept-Encoding" => "gzip",
          "Accept" => "application/json"
        },
        :body => body,
      }

      addCredentials(opts)

      # ...

      begin
        r = conn.post(endpoint, opts) do |req|
          req.options[:timeout] = Bezel.timeout
          req.options[:open_timeout] = 10
        end
      rescue Faraday::Error::TimeoutError => timeout_error
        # ...
        raise Bezel::TimeoutError.new(action)
      end
      
      # Manejo de errores

      action
    end
  end
end
