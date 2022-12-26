# frozen_string_literal: true

module ProxyApp
  class User
    attr_reader :id, :name, :email

    private_class_method :new

    def self.load_data
      data = JSON.parse(File.read(File.join(__dir__, 'user.json')))
      @users = {}

      for item in data
        @users[item['id']] = new(item)
      end
    end

    def initialize(data)
      for key in data.keys
        instance_variable_set("@#{key}", data[key])
      end
    end

    def self.find(id)
      @users[id]
    end

    def self.where(restrictions = {})
      result = []
      for id in @users.keys
        proxy_ip = @users[id]
        ok = true
        for restriction in restrictions.keys
          ok = false and break if proxy_ip.send(restriction) != restrictions[restriction]
        end
        result << proxy_ip if ok
      end

      result
    end

    def self.all
      result = []
      for id in @users.keys
        result << @users[id]
      end
      result
    end

    def proxy_packages
      ProxyPackage.where(user_id: id)
    end

    def inspect
      text = []
      for var in instance_variables
        text << "#{var.to_s.gsub('@', '')}: #{instance_variable_get(var)}"
      end
      "<User: #{text.join(', ')}>"
    end

    def to_s
      inspect
    end
  end
end
