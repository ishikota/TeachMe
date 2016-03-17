class User < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates :name, presence: true
  validates :student_id, length: { is: 8 }
  validates :student_id, format: { with: /\A[AB][0-9]{7}/ }
end
