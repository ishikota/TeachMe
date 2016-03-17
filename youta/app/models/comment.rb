class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :content, presence: true
end
