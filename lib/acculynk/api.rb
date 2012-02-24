module Acculynk
  module Api
    def avs_check
      command = 'cc_avs_only'
      options = {
        'card_no' => card_no,
        'card_exp_date' => card_exp_date,
        'cardholder_zip' => cardholder_zip
      }
      result = call_acculynk(command, options)
      if result['status'] == 'success'
        result.slice('tran_id')
      else
        false
      end
    end

    def checkbin
      result = call_acculynk('checkbin', 'card_bin' => card_no[0..9])
      result['in_network'] == 'TRUE' && result['qualified_internetpin'] == 'TRUE'
    end

    def initiate
      result = call_acculynk('initiate', 'card_no' => card_no)
      if result['status'] == 'success'
        result.slice('tran_id', 'guid', 'modulus', 'exponent')
      else
        false
      end
    end

    def authorize_token
      command = 'cc_auth_token'
      options = {
        'tran_id' => auth_token,
        'auth_amount' => auth_amount
      }
      result = call_acculynk(command, options)
      if result["status"] == "success" && result["auth_code"] == "AA"
        result.slice('tran_id')
      else
        false
      end
    end

    def authorize
      command = 'cc_authorize'
      options = {
        'card_no' => card_no,
        'auth_amount' => auth_amount,
        'card_exp_date' => card_exp_date,
        'cvv2' => cvv2,
        'cardholder_street' => cardholder_street,
        'cardholder_zip' => cardholder_zip
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id')
      else
        false
      end
    end

    def reverse
      command = 'cc_reverse'
      options = {
        'tran_id' => auth_token,
        'amount' => auth_amount
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id')
      else
        false
      end
    end

    def refund
      command = 'cc_refund'
      options = {
        'tran_id' => auth_token,
        'amount' => auth_amount
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id')
      else
        false
      end
    end

  end
end
