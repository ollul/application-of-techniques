# frozen_string_literal: true

module ProxyApp
  class Processor
    COMMANDS = {
      'help' => [HelpAction, ProxyApp::NullValidator],
      'list_users' => [ListUsersAction, ProxyApp::NullValidator],
      'list_user_packages' => [ListUserPackagesAction, ProxyApp::UserIDValidator],
      'show_package_info' => [ShowPackageInfoAction, ProxyApp::PackageIDValidator],
      'list_servers' => [ListServersAction, ProxyApp::NullValidator],
      'list_server_ips' => [ListServerIps, ProxyApp::ServerIDValidator],
      'show_ip_usage' => [ShowIpUsageAction, ProxyApp::NullValidator],
      'show_unused_ips' => [ShowUnusedIpsAction, ProxyApp::NullValidator],
      'show_income' => [ShowIncomeAction, ProxyApp::NullValidator]
    }.freeze

    def initialize(console)
      @console = console
    end

    def process
      @console.print_title
      @console.run do |line|
        parts = line.split(/\s+/)
        res = check_validity(line)
        exit if parts[0] == 'exit'
        if COMMANDS.keys.include?(parts[0]) && res[0]
          args = parts[1..].map(&:to_i)
          COMMANDS[parts[0]][0].new.perform(*args)
        else
          puts res[1]
        end
      end
    end

    private

    def check_validity(params)
      parts = params.split(/\s+/)
      cmd = COMMANDS[parts[0]]
      return [false, "Unknown command #{parts[0]}, please try again"] unless cmd

      cmd[1].validate(parts[1..])
    end
  end
end
