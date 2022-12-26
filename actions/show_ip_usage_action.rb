module ProxyApp
  class ShowIpUsageAction < GenericAction
    def perform
      ips = ProxyIp.all
      ips.sort_by { |ip| -ip.proxy_packages.count }.each do |ip|
        cnt = ip.proxy_packages.count
        next if cnt == 0

        puts "#{ip.ip}:#{ip.port} - #{cnt} users"
      end
    end
  end
end