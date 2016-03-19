class Lesson < ActiveRecord::Base
  has_many :editor_relationships, dependent: :destroy
  has_many :editors, through: :editor_relationships, source: :user
  has_many :subscriptions, dependent: :destroy
  has_many :students, through: :subscriptions, source: :user
  validates :title, presence: true
  validates :period, numericality: { greater_than: 0 }
  validates_inclusion_of :day_of_week, in: 0..6
end
