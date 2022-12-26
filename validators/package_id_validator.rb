module ProxyApp
  module PackageIDValidator
    def self.validate(params)
      package = ProxyPackage.find(params[0].to_i)
      if package.nil?
        [false, "No such proxy package with id #{params[0]}"]
      else
        [true, package]
      end
    end
  end
end
