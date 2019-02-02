class Player < ApplicationRecord

  has_many :scores, dependent: :destroy

  validates :username, uniqueness: true

  def display_name
    first_name || username
  end
end
