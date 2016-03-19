class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :user_id, presence: true
  validates :lesson_id, presence: true
end
