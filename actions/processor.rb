# frozen_string_literal: true

module ProxyApp
  class Processor
    def initialize(console)
      @console = console
    end

    def process
      @console.print_title
      @console.run do |line|
        parts = line.split(/\s+/)
        case parts[0]
        when 'help'
          puts 'Usage information:'
          puts 'list_users - list all users'
          puts 'list_user_packages <user_id> - list packages belonging to a user'
          puts 'show_package_info <proxy_package_id> - display info about package'
          puts 'list_servers - show a list of servers'
          puts 'list_server_ips <server_id> - show ips belonging to a server'
          puts 'show_ip_usage - list ips and user counts on each ip'
          puts 'show_unused_ips - list unused ips'
          puts 'show_income - list income from each user and total'
        when 'list_users'
          list_users
        when 'list_user_packages'
          if /\d+/ !~ parts[1].to_s
            puts 'Wrong arguments provided, please try again'
          else
            list_user_packages(parts[1].to_i)
          end
        when 'show_package_info'
          if /\d+/ !~ parts[1].to_s
            puts 'Wrong arguments provided, please try again'
          else
            show_package_info(parts[1].to_i)
          end
        when 'list_servers'
          list_servers
        when 'list_server_ips'
          if /\d+/ !~ parts[1].to_s
            puts 'Wrong arguments provided, please try again'
          else
            list_server_ips(parts[1].to_i)
          end
        when 'show_ip_usage'
          show_ip_usage
        when 'show_unused_ips'
          show_unused_ips
        when 'show_income'
          show_income
        when 'show_ip_income'
          show_ip_income
        else
          puts 'Unknown command, please try again or type help'
        end
      end
    end

    def list_users
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

    def list_user_packages(user_id)
      user = User.find(user_id)
      unless user
        puts "No such user with id #{user_id}"
        return
      end
      puts "Displaying packages for ##{user_id} #{user.name} #{user.email}"
      packages = ProxyPackage.where(user_id: user_id)
      packages.each do |package|
        ip_count = package.proxy_ips.count
        puts "id=#{package.id} price=$#{package.price_in_cents.to_f / 100} ip_count=#{ip_count}"
      end
    end

    def show_package_info(proxy_package_id)
      package = ProxyPackage.find(proxy_package_id)
      unless package
        puts "No such proxy package with id #{proxy_package_id}"
        return
      end
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

    def list_servers
      servers = Server.all
      servers.each do |server|
        ip_count = server.proxy_ips.count
        puts "id=#{server.id} name=#{server.name} main_ip=#{server.main_ip} ip_count=#{ip_count}"
      end
    end

    def list_server_ips(server_id)
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

    def show_ip_usage
      ips = ProxyIp.all
      ips.sort_by { |ip| -ip.proxy_packages.count }.each do |ip|
        cnt = ip.proxy_packages.count
        next if cnt == 0
        puts "#{ip.ip}:#{ip.port} - #{cnt} users"
      end
    end

    def show_unused_ips
      ips = ProxyIp.all
      total_cnt = 0
      ips.each do |ip|
        cnt = ip.proxy_packages.count
        next if cnt > 0
        total_cnt += 1
        puts "#{ip.ip}:#{ip.port}"
      end
      puts "#{total_cnt} unused IPs"
    end

    def show_income
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
