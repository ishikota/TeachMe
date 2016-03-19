class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  has_many :comments, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships
  has_many :good_relationships, dependent: :destroy
  has_many :good_people, through: :good_relationships, source: :user
  validates :title, presence: true
  validates :user_id, presence: true
  validates :lesson_id, presence: true
end
