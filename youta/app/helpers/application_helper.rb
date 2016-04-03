module ApplicationHelper

  # tag can be Tag object or string
  # if tag is passed as string then you also need to pass lesson object
  def tag_link(tag, lesson=nil)
    if tag.is_a?(Tag)
      lesson = tag.lesson
      tag = tag.name
    end

    # use option for spec/features/questions: it "should not set html paramter when all-tag is clicked
    option = tag == '全ての質問' ? {} : { tag: tag }
    lesson_questions_path(lesson, option)
  end

end
