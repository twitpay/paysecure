module Paysecure
  module Request
    def requestor_credentials_header
      %Q{<RequestorCredentials xmlns='http://Acculynk.com/Merchant.Web/'><Token>#{token}</Token><Version>#{api_version}</Version><MerchantID>#{partner_id}</MerchantID><UserCredentials><UserID>#{user_id}</UserID><Password>#{password}</Password></UserCredentials></RequestorCredentials>}
    end

    private
    def call_acculynk(cmd, hash)
      hash ||= {}
      hash["partner_id"] ||= partner_id
      args = CGI.escapeHTML(Gyoku.xml({ "acculynk" => hash }))
      xml = %Q{<?xml version="1.0" encoding="UTF-8"?> <env:Envelope xmlns:wsdl="https://paysecure.acculynk.net/merchant.web.service/" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"> <env:Header> #{requestor_credentials_header} </env:Header> <env:Body> <CallAcculynk xmlns='https://paysecure.acculynk.net/merchant.web.service/'><strCommand>#{cmd}</strCommand><strXML>#{args}</strXML></CallAcculynk> </env:Body> </env:Envelope> }
      #message = {strCommand: cmd, strXML: args}
      response = paysecure_client.call :call_acculynk, :xml => xml 
      result_xml = response.to_hash[:call_acculynk_response][:call_acculynk_result]
      result = Hash.from_xml(result_xml.sub(/<\?xml.*\?>/,''))["acculynk"]
    end

  end
end
