class LessonsController < ApplicationController
  include LessonEditHelper
  before_action :signed_in_user
  before_action :admin_user, except: :index

  def index
    @lessons = Lesson.all
  end
  def new
    @lesson = Lesson.new
  end
  def create
    @lesson = Lesson.new(user_params)
    students_csv = params[:lesson][:students_csv]
    if students_csv.present? && @lesson.save
      EditorRelationship.create(lesson_id: @lesson.id, user_id: current_user.id)
      read_csv_tags_for_lesson(@lesson.id, params[:lesson][:tags])
      students = read_csv_student_id(students_csv.path, "foobar")
      make_subscription(students)
      redirect_to lessons_path
    else
      render 'new'
    end
  end
  def edit
    @lesson = Lesson.find(params[:id])
  end
  def update
    @lesson = Lesson.find(params[:id])
    if @lesson.update_attributes(user_params)
      read_csv_tags_for_lesson(@lesson.id, params[:lesson][:tags])
      students_csv = params[:lesson][:students_csv]
      if students_csv.present?
        students = read_csv_student_id(students_csv.path, "foobar")
        make_subscription(students)
      end
      render 'edit'
    else
      render 'edit'
    end
  end
  def destroy
    Lesson.find(params[:id]).destroy
    redirect_to lessons_path
  end

  def students
    @lesson = Lesson.find(params[:id])
  end

  private

    def make_subscription(students)
      students.each { |student|
        student.subscriptions.create(lesson_id: @lesson.id)
      }
    end

    def user_params
      params.require(:lesson).permit(:day_of_week, :period, :title)
    end
end
