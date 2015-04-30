module Paysecure
  module Api
    def avs_check(args={})
      command = 'cc_avs_only'
      options = {
        'card_no' => args[:card_no],
        'card_exp_date' => args[:card_exp_date],
        'cardholder_zip' => args[:cardholder_zip]
      }
      result = call_acculynk(command, options)
      if result['status'] == 'success'
        result.slice('tran_id')
      else
        { :success => false }
      end
    end

    def checkbin(args={})
      result = call_acculynk('checkbin', 'card_bin' => args[:card_no][0..9])
      result['in_network'] == 'TRUE' && result['qualified_internetpin'] == 'TRUE'
    end

    def checkbin2(args={})
      result = call_acculynk('checkbin2', 'card_bin' => args[:card_no][0..9])
      if (result['status']).downcase == 'success'
        result.slice('errorcode', 'pinless_credit').merge(:success => true)
      else
        result.slice('errorcode').merge(:success => false)
      end
    end

    def initiate(args={})
      result = call_acculynk('initiate', 'card_no' => args[:card_no])
      if result['status'] == 'success'
        result.slice('tran_id', 'guid', 'modulus', 'exponent').merge(:success => true)
      else
        result.slice('errorcode', 'errormsg').merge({ :success => false })
      end
    end

    def pin_authorize(args={})
      command = 'authorize'
      options = {
        'partner_id' => partner_id,
        'tran_id' => args[:transaction_id],
        'auth_amount' => args[:auth_amount],
        'card_no' => args[:card_no],
        'card_exp_date' => args[:card_exp_date]
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id', 'apprcode').merge('success' => true)
      else
        result.slice('errorcode', 'errormsg', 'tran_id').merge('success' => false)
      end
    end

    def authorize_token(args={})
      command = 'cc_auth_token'
      options = {
        'tran_id' => args[:auth_token],
        'auth_amount' => args[:auth_amount]
      }
      result = call_acculynk(command, options)
      if result["status"] == "success" && result["auth_code"] == "AA"
        result.slice('tran_id').merge( :success => true )
      else
        { :success => false }
      end
    end

    def authorize(args={})
      command = 'authorize'
      options = {
        'partner_id' => partner_id,
        'card_no' => args[:card_no],
        'auth_amount' => args[:auth_amount],
        'card_exp_date' => args[:card_exp_date],
        'cvv2' => args[:cvv2],
        'cardholder_street' => args[:cardholder_street],
        'cardholder_zip' => args[:cardholder_zip]
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id').merge( :success => true )
      else
        { :success => false }
      end
    end

    def reverse(args={})
      command = 'cc_reverse'
      options = {
        'tran_id' => args[:auth_token],
        'amount' => args[:auth_amount]
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id').merge( :success => true )
      else
        { :success => false }
      end
    end

    def refund(args={})
      command = 'cc_refund'
      options = {
        'tran_id' => args[:auth_token],
        'amount' => args[:auth_amount]
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id').merge( :success => true )
      else
        { :success => false }
      end
    end

    def debit_refund(args={})
      command = 'refund'
      options = {
        'tran_id' => args[:auth_token],
        'amount' => args[:auth_amount]
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id').merge( :success => true )
      else
        { :success => false }
      end
    end

    def internet_credit(args={})
      command = 'internet_credit'
      options = {
        'card_no' => args[:card_no],
        'amount' => args[:amount],
        'partner_id' => partner_id,
        'card_exp_date' => args[:card_exp_date]
      }
      result = call_acculynk(command, options)
      if result["status"] == "success"
        result.slice('tran_id', 'apprcode').merge('success' => true)
      else
        result.slice('errorcode', 'errormsg', 'tran_id').merge('success' => false)
      end
    end

  end
end
