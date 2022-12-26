# frozen_string_literal: true

module ProxyApp
  class ProxyPackage < Model
    attr_reader :id, :user_id, :price_in_cents

    private_class_method :new

    def proxy_ips
      ProxyIpProxyPackage.get_proxy_ip_for_proxy_package_id(id)
    end
  end
end
