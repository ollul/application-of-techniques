
module ProxyApp
  class ShowPackageInfoAction < GenericAction
    def perform(proxy_package_id)
      package = ProxyPackage.find(proxy_package_id)
      ips = package.proxy_ips
      ip_count = ips.count
      puts "Proxy package ##{proxy_package_id}"
      puts "IP Count: #{ip_count}"
      puts "Price: $#{package.price_in_cents.to_f / 100}"
      puts "IP List:"
      groupped_ips = ips.group_by { |x| x.country }
      groupped_ips.each_key do |country|
        puts "Country: #{country} (#{groupped_ips[country].length} ips)"
        ip_list = groupped_ips[country].map { |x| "#{x.ip}:#{x.port}" }.join(', ')
        puts "IPs: #{ip_list}"
      end
    end
  end
end
