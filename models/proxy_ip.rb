# frozen_string_literal: true

module ProxyApp
  class ProxyIp
    attr_reader :id, :ip, :port, :country, :server_id

    private_class_method :new

    def self.load_data
      data = JSON.parse(File.read(File.join(__dir__, 'proxy_ip.json')))
      @proxy_ips = {}

      for item in data
        @proxy_ips[item['id']] = new(item)
      end
    end

    def initialize(data)
      for key in data.keys
        instance_variable_set("@#{key}", data[key])
      end
    end

    def self.find(id)
      @proxy_ips[id]
    end

    def self.where(restrictions = {})
      result = []
      for id in @proxy_ips.keys
        proxy_ip = @proxy_ips[id]
        ok = true
        for restriction in restrictions.keys
          ok = false and break if proxy_ip.send(restriction) != restrictions[restriction]
        end
        result << proxy_ip if ok
      end

      result
    end

    def self.all
      result = []
      for id in @proxy_ips.keys
        result << @proxy_ips[id]
      end
      result
    end

    def proxy_packages
      ProxyIpProxyPackage.get_proxy_package_for_proxy_ip_id(id)
    end

    def server
      Server.find(server_id)
    end

    def inspect
      text = []
      for var in instance_variables
        text << "#{var.to_s.gsub('@', '')}: #{instance_variable_get(var)}"
      end
      "<ProxyIp: #{text.join(', ')}>"
    end

    def to_s
      inspect
    end
  end
end
