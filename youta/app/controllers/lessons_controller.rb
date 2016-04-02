class LessonsController < ApplicationController
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
    if @lesson.save
      flash[:success] = "授業「#{@lesson.title}」を作成しました"
      EditorRelationship.create(lesson_id: @lesson.id, user_id: current_user.id)
      redirect_to lessons_path
    else
      flash[:danger] = "授業の作成に失敗しました"
      render 'new'
    end
  end
  def edit
    @lesson = Lesson.find(params[:id])
  end
  def update
    @lesson = Lesson.find(params[:id])
    if @lesson.update_attributes(user_params)
      flash[:success] = "変更を保存しました"
      render 'edit'
    else
      flash[:danger] = "変更を保存できませんでした"
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

    def user_params
      params.require(:lesson).permit(:day_of_week, :period, :title)
    end
end
