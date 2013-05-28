module Paysecure
  module Logger

    def logger
      @logger ||= Rails.logger ? Rails.logger : Logger.new(STDOUT)
    end

  end
end
