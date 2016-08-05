# == Schema Information
#
# Table name: guests
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Guest < ActiveRecord::Base

  has_many :options

  before_create :set_token

  private

    def set_token
      self.token = loop do
        random_token = SecureRandom.base64(24)
        break random_token unless Guest.exists?(token: random_token)
      end
    end
  
end
