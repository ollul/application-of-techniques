# frozen_string_literal: true

module ProxyApp
  class StringHelper
    def self.underscore(str)
      str = str.split(':').last if str.include?(':')
      str.gsub(/([A-Z])/) { |r| "_#{r.downcase}" }[1..]
    end

    def self.constantize(str)
      str = str.to_s.split(':').last
      const_name = str.to_s.gsub(/_[a-z]/) { |x| x[1..].upcase }
      const_name[0] = const_name[0].upcase
      ProxyApp.const_get(const_name)
    end
  end
end
