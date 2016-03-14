module Bezel
  class Client
    include Config

    # ...

    def conn
      @conn ||= Faraday.new(url: @base_uri) do |faraday|
        faraday.request :json
        # ...
        faraday.adapter  @adapter
      end
    end

    def invoke(mod, typ, action_name, params={})
      action = Bezel::Action.new(Target.new(@tenant, @tag, mod, typ), action_name, params)

      target = action.target
      endpoint = "/api/#{@api_version}/#{target.tenant}/#{target.module};#{target.tag}/#{target.type}?action=#{action_name}"

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
        r = conn.post(endpoint, opts[:body], opts[:headers]) do |req|
          req.options[:timeout] = Bezel.timeout.to_i
          req.options[:open_timeout] = 10
        end
      rescue Faraday::Error::TimeoutError => timeout_error
        # ...
        raise Bezel::TimeoutError.new(action)
      end
      
      # Error handling

      action
    end

    # ...
  end
end
