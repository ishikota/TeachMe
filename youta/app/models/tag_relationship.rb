class TagRelationship < ActiveRecord::Base
  belongs_to :tag
  belongs_to :question
  validates :tag_id, presence: true
  validates :question_id, presence: true
end
