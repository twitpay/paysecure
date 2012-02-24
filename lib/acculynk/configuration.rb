require 'acculynk/version'
module Acculynk
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Acculunk::Client}
    VALID_OPTIONS_KEYS = [
      :token,
      :partner_id,
      :user_id,
      :password,
      :endpoint,
      :proxy,
      :api_version,
      :card_no,
      :card_exp_date,
      :cardholder_street,
      :cardholder_zip,
      :cvv2,
      :auth_amount,
      :auth_token].freeze

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = 'https://cert.mws.acculynk.net/MWS/MerchantWebService.asmx?WSDL'.freeze

    # By default, don't use a proxy server
    DEFAULT_PROXY = nil

    DEFAULT_API_VERSION = '1.1.0.0'

    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "Acculynk Ruby Gem #{Acculynk::VERSION}".freeze

    DEFAULT_GATEWAY = nil

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to nil or default
    def reset
      VALID_OPTIONS_KEYS.each{|k| send("#{k}=", nil)}
      self.endpoint   = DEFAULT_ENDPOINT
      self.proxy      = DEFAULT_PROXY
      self.api_version    = DEFAULT_API_VERSION
      self
    end
  end
end
