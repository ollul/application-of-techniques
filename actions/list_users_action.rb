module ProxyApp
  class ListUsersAction < GenericAction
    def perform
      users = ProxyApp::User.all
      users.each do |user|
        total_ips = 0
        package_count = 0
        user.proxy_packages.each do |package|
          total_ips += package.proxy_ips.count
          package_count += 1
        end
        puts "id=#{user.id} name=#{user.name} email=#{user.email} package_count=#{package_count} used_ips_count=#{total_ips}"
      end
    end
  end
end
