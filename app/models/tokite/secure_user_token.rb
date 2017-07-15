module Tokite
  class SecureUserToken < ApplicationRecord
    belongs_to :user
  end
end
