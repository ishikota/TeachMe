class Tag < ActiveRecord::Base
  belongs_to :lesson
  validates :name, presence: true
  validates :lesson_id, presence: true
end
