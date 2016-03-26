class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  validates :user_id, presence: true
  validates :lesson_id, presence: true
  validates :user_id, uniqueness: { scope: :lesson_id,
    message: "この授業は既に受講しています" }
end
