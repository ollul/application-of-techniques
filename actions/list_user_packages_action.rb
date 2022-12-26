module ProxyApp
  class ListUserPackagesAction < GenericAction
    def perform(user_id)
      user = User.find(user_id)
      puts "Displaying packages for ##{user_id} #{user.name} #{user.email}"
      packages = ProxyPackage.where(user_id: user_id)
      packages.each do |package|
        ip_count = package.proxy_ips.count
        puts "id=#{package.id} price=$#{package.price_in_cents.to_f / 100} ip_count=#{ip_count}"
      end
    end
  end
end
