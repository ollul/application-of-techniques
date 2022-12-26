module ProxyApp
  class ListServersAction < GenericAction
    def perform
      servers = Server.all
      servers.each do |server|
        ip_count = server.proxy_ips.count
        puts "id=#{server.id} name=#{server.name} main_ip=#{server.main_ip} ip_count=#{ip_count}"
      end
    end
  end
end
