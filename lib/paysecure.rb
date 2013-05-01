require 'acculynk/client'
require 'acculynk/configuration'

module Acculynk
  extend Configuration

  class << self
    # Alias for Acculynk::Client.new
    #
    # @return [Acculynk::Client]
    def new(options={})
      Acculynk::Client.new(options)
    end

    # Delegate to Acculynk::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end
  end

end
