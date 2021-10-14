module API
  class GeoController < ApplicationController
    get '/api/geo' do
      halt 500, "Missing 'ip' parameter." unless params[:ip]

      ip = validate_ip(params[:ip])
      response = retrieve(ip)
      unless response
        response = ::GeoJS.get_geo(ip)[0]
        store(ip, response)
        # [{"organization_name":"GOOGLE","accuracy":1000,"asn":15169,"organization":"AS15169 GOOGLE","timezone":"America/Chicago","longitude":"-97.822","country_code3":"USA","area_code":"0","ip":"8.8.8.8","country":"United States","continent_code":"NA","country_code":"US","latitude":"37.751"}]
      end
      
      respond(response)
    end

    get '/api/ips' do
      $ip_cache ||= {}
      target_country_code = params[:country].downcase if params[:country]
      target_city = params[:city].downcase if params[:city]

      excluded_ips = []
      $ip_cache.each_pair do |ip, geo|
        excluded_ips << ip if params[:country] && geo["country_code"].downcase != target_country_code
        excluded_ips << ip if params[:city] && geo["city"].try(:downcase) != target_city
      end if params[:country] || params[:city]

      respond($ip_cache.except(*excluded_ips))
    end

    helpers do
      def validate_ip(ip)
        # Quick and dirty error checking on the ip address format.
        halt 500, "Invalid IPv4 address: #{ip}" unless ip =~ /^[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*$/

        return ip
      end

      def retrieve(ip)
        # Look up an IP before making an external API call.
        $ip_cache ||= {}
        $ip_cache[ip]
      end
      
      def store(ip, geo)
        # Save geo results for an IP address.
        $ip_cache ||= {}
        $ip_cache[ip] = geo
      end

    end
  end
end