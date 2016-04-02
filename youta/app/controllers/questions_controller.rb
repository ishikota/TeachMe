class QuestionsController < ApplicationController
  before_action :signed_in_user

  def index
    @lesson = Lesson.find(params[:lesson_id])
  end

  def new
    @lesson = Lesson.find(params[:lesson_id])
    @question = @lesson.questions.build
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @question = Question.new(question_params)
    if params[:comment][:content].present? && @question.save
      @question.tag_relationships.create(tag_id: params[:question][:tags].to_i)
      @question.comments.create(user_id: current_user.id, content: params[:comment][:content])
      redirect_to lesson_question_path(@lesson, @question)
    else
      flash[:warning] = "質問の投稿に失敗しました."
      render :new
    end
  end

  def show
    @lesson = Lesson.find(params[:lesson_id])
    @question = Question.find(params[:id])
  end

  private
    def question_params
      params.require(:question).permit(:title)
          .merge( user_id: current_user.id, lesson_id: params[:lesson_id] )
    end

end
