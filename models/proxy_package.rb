# frozen_string_literal: true

module ProxyApp
  class ProxyPackage
    attr_reader :id, :user_id, :price_in_cents

    private_class_method :new

    def self.load_data
      data = JSON.parse(File.read(File.join(__dir__, 'proxy_package.json')))
      @proxy_packages = {}

      for item in data
        @proxy_packages[item['id']] = new(item)
      end
    end

    def initialize(data)
      for key in data.keys
        instance_variable_set("@#{key}", data[key])
      end
    end

    def self.find(id)
      @proxy_packages[id]
    end

    def self.where(restrictions = {})
      result = []
      for id in @proxy_packages.keys
        proxy_ip = @proxy_packages[id]
        ok = true
        for restriction in restrictions.keys
          ok = false and break if proxy_ip.send(restriction) != restrictions[restriction]
        end
        result << proxy_ip if ok
      end

      result
    end

    def proxy_ips
      ProxyIpProxyPackage.get_proxy_ip_for_proxy_package_id(id)
    end

    def inspect
      text = []
      for var in instance_variables
        text << "#{var.to_s.gsub('@', '')}: #{instance_variable_get(var)}"
      end
      "<ProxyPackage: #{text.join(', ')}>"
    end

    def to_s
      inspect
    end
  end
end
