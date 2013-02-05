require 'acculynk/api'
require 'acculynk/configuration'
require 'acculynk/request'
require 'savon'


module HTTPI
  module Adapter
    class NetHTTP < Base
      alias request_old request
      
      def request(method)
        unless REQUEST_METHODS.include? method
          raise NotSupportedError, "Net::HTTP does not support custom HTTP methods"
        end

        do_request(method) do |http, http_request|
          http.ssl_version = :SSLv3
          http_request.body = @request.body
          if @request.on_body then
            http.request(http_request) do |res|
              res.read_body do |seg|
                @request.on_body.call(seg)
              end
            end
          else
            http.request http_request
          end
        end
      rescue OpenSSL::SSL::SSLError
        raise SSLError
      rescue Errno::ECONNREFUSED   # connection refused
        $!.extend ConnectionError
        raise
      end
    end
  end
end

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
      @client ||= Savon::Client.new(:ssl_version => :SSLv3, soap_header: requestor_credentials_header ) do
       # binding.pry
        wsdl Acculynk.options[:endpoint]
        convert_request_keys_to :camelcase
      end
      
    end
  end

end
