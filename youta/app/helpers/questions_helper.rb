module QuestionsHelper
  def have_right_to_comment(lesson, user)
    lesson.students.include?(user) || lesson.editors.include?(user)
  end
end
