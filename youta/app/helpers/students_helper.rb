module StudentsHelper
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
        student = User.find_by_student_id(student_id.downcase)
        if student.nil?  # if student is not registered yet
          params = { student_id: student_id, name: def_name, password: initial_password, password_confirmation: initial_password }
          student = User.create(params)
        else
          student
        end
      }.select { |student| student.valid? }
    end

    def read_student_from_csv(file_path)
      data = CSV.read(file_path)
      data[0]
    end
end
