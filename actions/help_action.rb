# frozen_string_literal: true

module ProxyApp
  class HelpAction < GenericAction
    def perform
      puts 'Usage information:'
      puts 'list_users - list all users'
      puts 'list_user_packages <user_id> - list packages belonging to a user'
      puts 'show_package_info <proxy_package_id> - display info about package'
      puts 'list_servers - show a list of servers'
      puts 'list_server_ips <server_id> - show ips belonging to a server'
      puts 'show_ip_usage - list ips and user counts on each ip'
      puts 'show_unused_ips - list unused ips'
      puts 'show_income - list income from each user and total'
    end
  end
end
