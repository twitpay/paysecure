class Acculynk
  config = YAML.load_file("#{Rails.root}/config/acculynk.yml") || {}
  common = config['common'] || {}
  common.update(config[Rails.env] || {})
  Config = OpenStruct.new(common)

  attr_accessor :card_no, :card_exp_date, :cardholder_zip, :auth_amount
  attr_accessor :cardholder_street, :cvv2 # for cert only
  attr_accessor :auth_token

  attr_accessor :result

  attr_accessor :debug

  def initialize(args={ })
    args = HashWithIndifferentAccess.new(args)
    self.card_no         = args[:card_no]
    self.card_exp_date   = args[:card_exp_date]
    self.cardholder_zip  = args[:cardholder_zip]
    self.auth_amount     = args[:auth_amount]
    self.auth_token      = args[:auth_token]
  end

  def auth_amount=(amt)
    @auth_amount = (amt.to_f * 100).to_i
  end

  def client
    @client ||= Savon::Client.new do
      wsdl.document = Config.endpoint
    end
  end

  def requestor_credentials_header
    %Q{<RequestorCredentials xmlns='http://Acculynk.com/Merchant.Web/'><Token>#{Config.token}</Token><Version>#{Config.version}</Version><MerchantID>#{Config.partner_id}</MerchantID><UserCredentials><UserID>#{Config.user_id}</UserID><Password>#{Config.password}</Password></UserCredentials></RequestorCredentials>}
  end

  def log_error(e)
    HoptoadNotifier.notify(Exception.new("Acculynk error: #{e}"))
      RAILS_DEFAULT_LOGGER.warn "Acculynk error: #{e}"
  end

  def avs_check
    unless cardholder_zip =~ /^\d\d\d\d\d$/
      self.cardholder_zip = "01234"
    end
    call_acculynk("cc_avs_only", "card_no" => card_no, "card_exp_date" => card_exp_date, "cardholder_zip" => cardholder_zip)
    if result["status"] == "success"
      log_error "AVS bad tranny: #{result.to_yaml}" if result["tran_id"] == 0
        result["tran_id"]
    else
      log_error "AVS check failed: #{result.to_yaml}"
        false
    end
  end

  def pin_checkbin
    call_acculynk("checkbin", "card_bin" => card_no[0..9])
    result["in_network"] == "TRUE" && result["qualified_internetpin"] == "TRUE"
  end

  def pin_initiate
    call_acculynk("initiate", "card_no" => card_no)
    if result["status"] == "success"
      result.slice("tran_id", "guid", "modulus", "exponent")
    else
      false
    end
  end

  def authorize_token
    call_acculynk("cc_auth_token", "tran_id" => auth_token, "auth_amount" => auth_amount)
    if result["status"] == "success" && result["auth_code"] == "AA"
      result["tran_id"]
    else
      false
    end
  end

  def authorize
    call_acculynk("cc_authorize", "card_no" => card_no, "auth_amount" => auth_amount, "card_exp_date" => card_exp_date,
                  "cvv2" => cvv2, "cardholder_street" => cardholder_street, "cardholder_zip" => cardholder_zip)
    if result["status"] == "success"
      result["tran_id"]
    else
      false
    end
  end

  def reverse
    call_acculynk("cc_reverse", "tran_id" => auth_token, "amount" => auth_amount)
    if result["status"] == "success"
      result["tran_id"]
    else
      false
    end
  end

  def refund
    call_acculynk("cc_refund", "tran_id" => auth_token, "amount" => auth_amount)
    if result["status"] == "success"
      result["tran_id"]
    else
      false
    end
  end

  def auth_response_hack
    t = result["auth_code"] == "AA" ? "GOOD" : "FAIL"
    "#{t}-#{result['auth_code']}-#{result['auth_response']}"
  end

  def call_acculynk(cmd, hash)
    hash ||= { }
    hash["partner_id"] ||= Config.partner_id
    args = CGI.escapeHTML(Gyoku.xml({ "acculynk" => hash }))
    response = client.request :call_acculynk do
      soap.xml = %Q{<?xml version="1.0" encoding="UTF-8"?>
                    <env:Envelope xmlns:wsdl="https://paysecure.acculynk.net/merchant.web.service/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
                    <env:Header>
                    #{requestor_credentials_header}
                    </env:Header>
                    <env:Body>
                    <CallAcculynk xmlns='https://paysecure.acculynk.net/merchant.web.service/'><strCommand>#{cmd}</strCommand><strXML>#{args}</strXML></CallAcculynk>
                    </env:Body>
                    </env:Envelope>
      }
    end
    result_xml = response.to_hash[:call_acculynk_response][:call_acculynk_result]
    self.result = Hash.from_xml(result_xml.sub(/<\?xml.*\?>/,''))["acculynk"]
  end
end
