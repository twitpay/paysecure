module Acculynk
  module Api
    def checkbin
      result = call_acculynk("initiate", "card_no" => card_no)
      if result["status"] == "success"
        result.slice("tran_id", "guid", "modulus", "exponent")
      else
        false
      end
    end
  end
end
