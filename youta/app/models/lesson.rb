class Lesson < ActiveRecord::Base
  validates :title, presence: true
  validates :period, numericality: { greater_than: 0 }
  validates_inclusion_of :day_of_week, in: 0..6
end
