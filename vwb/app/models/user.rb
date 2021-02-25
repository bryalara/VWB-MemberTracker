class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  def self.from_google(access_token)
    data = access_token.info
    identify = Identify.find_by(:provider => access_token.provider, :uid => access_token.uid)

    if identify
        return identify.user
    else
        user = User.find_by(:email => access_token.email)
        if !user
            user = User.create(
                email: data["email"],
                password: Devise.friendly_token[0,20]
            )
        end
            identify = Identify.create(
                provider: access_token.provider,
                uid: access_token.uid,
                user: user
            )
        return user
    end
  end
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable
  has_many :identifies
end
