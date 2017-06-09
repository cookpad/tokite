class User < ApplicationRecord
  has_many :rules, dependent: :destroy

  def self.create_group_user!(name)
    uuid = SecureRandom.uuid.tr("-", "")
    create!(
      provider: "GROUP",
      uid: uuid,
      email: uuid,
      image_url: "",
      name: name
    )
  end

  def group_user?
    provider == "GROUP"
  end
end