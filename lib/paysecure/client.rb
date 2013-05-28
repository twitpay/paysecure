require 'paysecure/api'
require 'paysecure/configuration'
require 'paysecure/logger'
require 'paysecure/request'
require 'savon'

module HTTPI
  module Adapter
    class NetHTTP < Base
      alias request_old request
      def request(method)
        @request.ssl = true
        @request.auth.ssl.ssl_version = :TLSv1
        @request.auth.ssl.verify_mode = :none
        request_old(method)
      end
    end
  end
end

module Paysecure

  class Client
    include Request
    include Api
    include Logger

    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = Paysecure.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def paysecure_client
      @client ||= Savon::Client.new(:ssl_version => :SSLv3, soap_header: requestor_credentials_header ) do
       # binding.pry
        wsdl Paysecure.options[:endpoint]
        convert_request_keys_to :camelcase
      end
      
    end
  end

end
