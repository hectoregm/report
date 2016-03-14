module Bezel
  module Config

    VALID_OPTIONS_KEYS = [
            :auth_token,
            :base_uri,
            :cache,
            :user,
            :password,
            :tenant,
            :tag
            # ...
    ]

    DEFAULT_VALUES = {
            :auth_token => ENV['BEZEL_AUTH_TOKEN'],
            :base_uri => ENV['BEZEL_BASE_URI'] || "http://localhost:8080",
            :cache => ENV['BEZEL_CACHE'] || false,
            :user => ENV['BEZEL_USER'],
            :password => ENV['BEZEL_PASSWORD'],
            :tenant => ENV['BEZEL_TENANT'] || 'c3',
            :tag => ENV['BEZEL_TAG'] || 'c3',
            # ...
    }.freeze

    attr_accessor *VALID_OPTIONS_KEYS
    
    # ...

    def self.extended(base)
      base.reset
    end

    def reset
      VALID_OPTIONS_KEYS.each { |k| send("#{k}=",DEFAULT_VALUES[k]) }
      self
    end
  end
end