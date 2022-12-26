# frozen_string_literal: true

module ProxyApp
  class Server < Model
    attr_reader :id, :name, :main_ip

    has_many :proxy_ip, :server_id
  end
end
