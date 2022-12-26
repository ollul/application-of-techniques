module ProxyApp
  module ServerIDValidator
    def self.validate(params)
      server = Server.find(params[0].to_i)
      if server
        [true, server]
      else
        [false, "No such server with id #{params[0]}"]
      end
    end
  end
end
