module MapPoint
  class Common < Service
    endpoint(:uri => 'http://findv3.mappoint.net/Find-30/Common.asmx?WSDL',
             :version => 1
             )

    class << self
      attr_accessor :token_ttl
    end

    self.token_ttl = 240 # 4 hours in minutes

    def get_client_token(ip_address, token_ttl=self.class.token_ttl)
      response = mp_invoke('GetClientToken') do |over|
        over.add('map:specification') do |msg|
          msg.add 'map:ClientIPAddress', ip_address
          msg.add 'map:TokenValidityDurationMinutes', token_ttl
        end
      end
      parse_token(response.document)
    end

  private
    def parse_token(doc)
      xml_to_str(doc.xpath('//xmlns:GetClientTokenResult/text()', ns))
    end
  end
end
