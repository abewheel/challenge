# GeoJS API integration.
# https://www.geojs.io/docs/v1/endpoints/geo/ 

class GeoJS
  ENDPOINT = {
    geo: "https://get.geojs.io/v1/ip/geo.json"
  }

  def self.get_geo(ips)
    puts ENDPOINT[:geo]
    
    # This didn't work: RestClient::SSLCertificateNotVerified
    # SSL_connect returned=1 errno=0 state=error: certificate verify failed (unable to get local issuer certificate)
    # RestClient.get(ENDPOINT[:geo], params: { ip: ips })

    # This didn't work: (same)
    # gjs = RestClient::Resource.new(ENDPOINT[:geo], ssl_ca_file: 'config/certs/self_signed/cert.pem')
    # gjs.get(params: { ip: ips })

    # Don't verify SSL when running locally; this is often problematic.
    verify_ssl = ENV['RACK_ENV'] == 'production' ? true : false
    gjs = RestClient::Resource.new(ENDPOINT[:geo], verify_ssl: verify_ssl)
    response = gjs.get(params: { ip: ips })
    JSON.parse(response)
  end
end