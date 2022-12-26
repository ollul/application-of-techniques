# frozen_string_literal: true

module ProxyApp
  class ProxyIpProxyPackage
    attr_reader :proxy_ip_id, :proxy_package_id

    private_class_method :new

    def self.load_data
      data = JSON.parse(File.read(File.join(__dir__, 'proxy_ip_proxy_package.json')))
      @proxy_ip_to_proxy_packages = Hash.new { |h, k| h[k] = [] }
      @proxy_package_to_proxy_ips = Hash.new { |h, k| h[k] = [] }

      for item in data
        @proxy_ip_to_proxy_packages[item['proxy_ip_id']] << item['proxy_package_id']
        @proxy_package_to_proxy_ips[item['proxy_package_id']] << item['proxy_ip_id']
      end
    end

    def self.get_proxy_ip_for_proxy_package_id(id)
      result = []
      for pid in @proxy_package_to_proxy_ips[id]
        result << ProxyIp.find(pid)
      end

      result
    end

    def self.get_proxy_package_for_proxy_ip_id(id)
      result = []
      for pid in @proxy_ip_to_proxy_packages[id]
        result << ProxyPackage.find(pid)
      end

      result
    end
  end
end