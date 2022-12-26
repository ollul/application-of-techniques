# frozen_string_literal: true

require 'json'

module ProxyApp
  def self.run
    ProxyApp::Server.load_data
    ProxyApp::ProxyIp.load_data
    ProxyApp::User.load_data
    ProxyApp::ProxyPackage.load_data
    ProxyApp::ProxyIpProxyPackage.load_data

    console = ProxyApp::Console.new
    processor = ProxyApp::Processor.new(console)
    processor.process
  end
end

require_relative './helpers/string_helper'
require_relative './models/model'
require_relative './models/proxy_ip'
require_relative './models/server'
require_relative './models/proxy_package'
require_relative './models/proxy_ip_proxy_package'
require_relative './models/user'
Dir[File.join(__dir__, 'validators/*')].each do |file|
  require_relative file
end
Dir[File.join(__dir__, 'actions/*')].each do |file|
  next if file.include?('processor') || file.include?('console')

  require_relative file
end
require_relative './actions/console'
require_relative './actions/processor'

ProxyApp.run
