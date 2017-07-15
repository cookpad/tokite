module Tokite
  class User < ApplicationRecord
    has_many :rules, dependent: :destroy

    has_one :secure_user_token

    delegate :token, to: :secure_user_token, allow_nil: true

    def self.login!(auth)
      user = find_or_initialize_by(
        provider: auth[:provider],
        uid: auth[:uid],
      )
      if user.persisted?
        user.secure_user_token.update!(token: auth[:credentials][:token])
      else
        user.assign_attributes(
          name: auth[:info][:name],
          image_url: auth[:info][:image],
        )
        user.build_secure_user_token(token: auth[:credentials][:token])
        transaction do
          user.save!
        end
      end
      user
    end

    def self.create_group_user!(name)
      uuid = SecureRandom.uuid.tr("-", "")
      create!(
        provider: "GROUP",
        uid: uuid,
        image_url: "",
        name: name
      )
    end
  
    def group_user?
      provider == "GROUP"
    end

    def name_with_provider
      "#{name} (#{provider})"
    end
  end
end
