require 'paysecure/client'
require 'paysecure/configuration'

module Paysecure
  extend Configuration

  class << self
    # Alias for Paysecure::Client.new
    #
    # @return [Paysecure::Client]
    def new(options={})
      Paysecure::Client.new(options)
    end

    # Delegate to Paysecure::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end
  end

end
