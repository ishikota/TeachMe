class LessonsController < ApplicationController
  include LessonEditHelper

  def index
    @lessons = Lesson.all
  end
  def new
    @lesson = Lesson.new
  end
  def create
    @lesson = Lesson.new(user_params)
    if @lesson.save
      read_csv_tags_for_lesson(@lesson.id, params[:lesson][:tags])
      read_csv_student_id(params[:lesson][:students_csv].path, "foobar")
      redirect_to lessons_path
    else
      render 'new'
    end
  end
  def edit
    @lesson = Lesson.find(params[:id])
  end

  private

    def user_params
      params.require(:lesson).permit(:day_of_week, :period, :title)
    end
end
