class Tag < ActiveRecord::Base
  has_many :tag_relationships, dependent: :destroy
  has_many :questions, through: :tag_relationships
  belongs_to :lesson
  validates :name, presence: true
  validates :lesson_id, presence: true
  validates :name, uniqueness: { scope: :lesson_id,
    message: "同じ名前のタグが既に存在しています" }
end
