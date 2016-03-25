class User < ActiveRecord::Base
  before_save { self.student_id = student_id.downcase }
  has_many :comments
  has_many :questions
  has_many :editor_relationships, dependent: :destroy
  has_many :lectures, through: :editor_relationships, source: :lesson
  has_many :subscriptions, dependent: :destroy
  has_many :lessons, through: :subscriptions
  has_many :good_relationships
  has_many :good_questions, through: :good_relationships, source: :question
  validates :name, presence: true
  validates :student_id, length: { is: 8 },
    format: { with: /\A[ABab][0-9]{7}/ },
    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def comment(question, content)
    comments.create(question_id: question.id, content: content)
  end

  def post_question(lesson_id, title, description, tag)
    q = questions.create(lesson_id: lesson_id, title: title)
    comment(q, description)  # Add question description as first comment
    q.tag_relationships.create(tag_id: tag.id)
    return q
  end

  def post_good(question)
    good_relationships.create(question_id: question.id)
  end

  def cancel_good(question)
    good_relationships.find(question.id).destroy
  end

end
