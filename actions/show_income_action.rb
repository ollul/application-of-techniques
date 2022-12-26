module ProxyApp
  class ShowIncomeAction < GenericAction
    def perform
      users = User.all
      total = 0
      users.each do |user|
        puts "User #{user.email}##{user.id}"
        user_total = 0
        user.proxy_packages.each do |package|
          puts "Proxy package ##{package.id}, ip count #{package.proxy_ips.count}, income $#{package.price_in_cents.to_f / 100}"
          user_total += package.price_in_cents
        end
        puts "User total $#{user_total.to_f / 100}"
        total += user_total
      end
      puts "Total income $#{total.to_f / 100}"
    end
  end
end