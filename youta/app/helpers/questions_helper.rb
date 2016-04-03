module QuestionsHelper
  def have_right_to_comment(lesson, user)
    lesson.students.include?(user) || lesson.editors.include?(user)
  end

  # tags: array of Tag obj
  # current_tag, all_tag : string
  def manage_tags(tags, current_tag, all_tag)
    tags = tags.map { |tag| tag.name }
    if current_tag.blank? || current_tag == all_tag  # no tag filter
      current_tag = all_tag
      rest_tag = tags
    else
      rest_tag = tags.select{ |tag| tag != current_tag }.unshift(all_tag)
    end
    return [current_tag, rest_tag]
  end
end
