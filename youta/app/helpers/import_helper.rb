module ImportHelper
  require 'csv'


  # convert csv forat student ids to User object array
  def read_csv_student_id(filename, initial_password)
    student_ids = read_student_from_csv(filename)
    import_students(student_ids, initial_password)
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

end
