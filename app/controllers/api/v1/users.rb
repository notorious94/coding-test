module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults
      include API::V1::Authentication

      resource :users do
      end
    end
  end
end
