module ProxyApp
  class ListServerIps < GenericAction
    def perform(server_id)
      server = Server.find(server_id)
      unless server
        puts "No such server with id #{server_id}"
        return
      end
      ips = server.proxy_ips
      ips.each do |ip|
        puts "#{ip.ip}:#{ip.port}"
      end
      puts "#{ips.count} IPs total"
    end
  end
end
