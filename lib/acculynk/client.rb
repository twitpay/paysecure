require 'acculynk/api'
require 'acculynk/configuration'
require 'acculynk/request'
require 'savon'

module Acculynk

  class Client
    include Request
    include Api

    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = Acculynk.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def acculynk_client
      @client ||= Savon::Client.new do
        wsdl.document = endpoint
      end
    end
  end

end
