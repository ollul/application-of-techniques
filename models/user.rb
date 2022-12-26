# frozen_string_literal: true

module ProxyApp
  class User < Model
    attr_reader :id, :name, :email

    def proxy_packages
      ProxyPackage.where(user_id: id)
    end
  end
end
