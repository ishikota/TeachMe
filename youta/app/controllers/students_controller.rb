class StudentsController < ApplicationController
  include LessonEditHelper
  before_action :signed_in_user
  before_action :editor_check

  def index
    @lesson = Lesson.find(params[:lesson_id])
    @students = @lesson.students
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @students = @lesson.students

    students_csv = params[:students_csv]
    if students_csv.nil?
      flash.now[:warning] = "csvファイルを添付してください"
      render 'index'
    else
      # Create not registered student with initial password 'foobar'
      students = read_csv_student_id(students_csv.path, "foobar")
      # Make students subscribe the lesson
      students.each { |student|
        student.subscriptions.create(lesson_id: @lesson.id)
      }
      redirect_to lesson_students_path(@lesson)
    end
  end

  def destroy
    lesson = Lesson.find(params[:lesson_id])
    Subscription.find_by(user_id: params[:id], lesson_id: lesson.id).destroy
    # TODO flash
    redirect_to lesson_students_path(lesson)
  end

  private
    def editor_check
      @lesson = Lesson.find(params[:lesson_id])
      unless @lesson.editors.include?(current_user)
        flash[:warning] = "あなたはこの授業の編集権限を持っていません"
        redirect_to root_path
      end
    end
end
