require 'clearwater/roda/version'
require 'clearwater/roda/application'

module Clearwater
  module Roda
    module_function

    def build_app name
      Application.new(name).build
    end
  end
end
