# frozen_string_literal: true

class Score < ApplicationRecord
  belongs_to :player
  before_save { self.date ||= Date.current }

  scope :for_the, ->(range) do
    where('date >= ? AND date <= ?',
          Date.current.public_send("beginning_of_#{range}".to_sym).to_date,
          Date.current.public_send("end_of_#{range}".to_sym).to_date)
  end
end
