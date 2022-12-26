module ProxyApp
  class ShowUnusedIpsAction < GenericAction
    def perform
      ips = ProxyIp.all
      total_cnt = 0
      ips.each do |ip|
        cnt = ip.proxy_packages.count
        next if cnt.postive?

        total_cnt += 1
        puts "#{ip.ip}:#{ip.port}"
      end
      puts "#{total_cnt} unused IPs"
    end
  end
end
