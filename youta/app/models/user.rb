class User < ActiveRecord::Base
  has_many :comments
  has_many :questions
  has_many :editor_relationships, dependent: :destroy
  has_many :lessons, through: :editor_relationships
  validates :name, presence: true
  validates :student_id, length: { is: 8 }
  validates :student_id, format: { with: /\A[AB][0-9]{7}/ }

  def comment(question, content)
    comments.create(question_id: question.id, content: content)
  end

end
