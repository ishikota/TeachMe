class QuestionsController < ApplicationController
  include QuestionsHelper
  before_action :signed_in_user

  def index
    all_tag = "全ての質問"
    @lesson = Lesson.find(params[:lesson_id])
    if params[:tag].present?
      @questions = @lesson.questions.joins(:tags).merge(Tag.where(name: params[:tag]))
    else
      @questions = @lesson.questions
    end
    @current_tag, @rest_tags = manage_tags(@lesson.tags, params[:tag], all_tag)
  end

  def new
    @lesson = Lesson.find(params[:lesson_id])
    @question = @lesson.questions.build
  end

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @question = Question.new(question_params
                             .merge( user_id: current_user.id, lesson_id: params[:lesson_id] ))
    q_detail = params[:comment][:content]
    if q_detail.present? && @question.save
      @question.tag_relationships.create(tag_id: params[:question][:tags].to_i)
      @question.comments.create(user_id: current_user.id, content: q_detail)
      redirect_to lesson_question_path(@lesson, @question)
    else
      @question.errors.add(:detail, "詳細が記入されていません") unless q_detail.present?
      flash[:warning] = "質問の投稿に失敗しました."
      render :new
    end
  end

  def show
    @lesson = Lesson.find(params[:lesson_id])
    @question = Question.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:lesson_id])
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      if question_params.has_key? :solved
        content = @question.solved ? "close" : "open"
        Comment.create(content: content, question_id: @question.id, user_id: current_user.id, official: true)
      end
      redirect_to lesson_question_path(@lesson, @question)
    end
  end


  private
    def question_params
      params.require(:question).permit(:title, :solved)
    end

end
