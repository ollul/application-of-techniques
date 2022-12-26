# frozen_string_literal: true

module ProxyApp
  module NullValidator
    def self.validate(params)
      [true, nil]
    end
  end
end
