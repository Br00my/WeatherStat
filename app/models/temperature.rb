class Temperature < ApplicationRecord
  validates :time, :value, presence: true
  validates :time, uniqueness: true
end
