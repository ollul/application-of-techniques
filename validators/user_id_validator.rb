module ProxyApp
  module UserIDValidator
    def self.validate(params)
      user = User.find(params[0].to_i)
      if user
        [true, user]
      else
        [false, "No such user with id #{params[0]}"]
      end
    end
  end
end