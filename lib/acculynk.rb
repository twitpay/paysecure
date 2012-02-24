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
  end

end
