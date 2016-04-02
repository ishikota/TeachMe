class StudentsController < ApplicationController
  include StudentsHelper
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
      new_subscriptions = make_subscriptions(@lesson, students)
      flash[:success] = "#{new_subscriptions.size}人の生徒を受講者リストに追加しました"
      redirect_to lesson_students_path(@lesson)
    end
  end

  def destroy
    lesson = Lesson.find(params[:lesson_id])
    Subscription.find_by(user_id: params[:id], lesson_id: lesson.id).destroy
    flash[:success] = "受講者リストから削除しました"
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
