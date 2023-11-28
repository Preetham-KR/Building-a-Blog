class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #   :confirmable, :registerable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
