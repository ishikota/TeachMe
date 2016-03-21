class Lesson < ActiveRecord::Base
  has_many :editor_relationships, dependent: :destroy
  has_many :editors, through: :editor_relationships, source: :user
  has_many :subscriptions, dependent: :destroy
  has_many :students, through: :subscriptions, source: :user
  has_many :questions
  has_many :tags
  validates :title, presence: true
  validates :period, numericality: { greater_than: 0 }
  validates_inclusion_of :day_of_week, in: 0..6


  def self.day_of_week_to_str(day_of_week)
    DAY_OF_WEEK_MAP[day_of_week]
  end

  def self.period_to_str(period)
    period.to_s + '限' unless period == 0
  end

  private
    DAY_OF_WEEK_MAP = ['月曜','火曜','水曜','木曜','金曜']

end
