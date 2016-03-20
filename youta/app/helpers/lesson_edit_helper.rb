module LessonEditHelper
  require 'csv'

  # convert csv forat student ids to User object array
  def read_csv_student_id(filename, initial_password)
    student_ids = read_student_from_csv(filename)
    import_students(student_ids, initial_password)
  end

  # convert comma separated tags to Tag object array
  def read_csv_tags_for_lesson(lesson_id, tag_src)
    tags = tag_src.split(',')
    tags = tags.map { |tag| tag.strip }
    import_tags(lesson_id, tags)
  end


  private
    def import_students(student_ids, initial_password)
      def_name = "Sophian"
      students = []
      student_ids.map { |student_id| 
        User.create(student_id: student_id, name: def_name,
                    password: initial_password, password_digest: initial_password)
      }.select { |student| !student.blank? }
    end

    def read_student_from_csv(file_path)
      data = CSV.read(file_path)
      data[0]
    end

    def import_tags(lesson_id, new_tags)
      old_tags = Tag.where(lesson_id: lesson_id)
      old_tags = old_tags.map { |tag| tag.name }
      create_tags = new_tags - old_tags
      destroy_tags = old_tags - new_tags
      for tag in create_tags
        Tag.create(name: tag, lesson_id: lesson_id)
      end
      for tag in destroy_tags
        Tag.find_by_name(tag).destroy
      end
      Tag.where(lesson_id: lesson_id)
    end

end
