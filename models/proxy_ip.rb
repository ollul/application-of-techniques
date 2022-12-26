# frozen_string_literal: true

module ProxyApp
  class ProxyIp < Model
    attr_reader :id, :ip, :port, :country, :server_id

    belongs_to :server, :server_id

    def proxy_packages
      ProxyIpProxyPackage.get_proxy_package_for_proxy_ip_id(id)
    end
  end
end
