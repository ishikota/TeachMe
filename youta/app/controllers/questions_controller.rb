class QuestionsController < ApplicationController
  def index
    @lesson = Lesson.find(params[:lesson_id])
    @questions = Question.all
  end

  def new
    @lesson = Lesson.find(params[:lesson_id])
    @question = @lesson.questions.build
  end

  def create
    title = params[:question][:title]
    comment = params[:comment][:content]
    tag = Tag.find(params[:question][:tags])
    @lesson = Lesson.find(params[:lesson_id])
    @question = current_user.post_question(params[:lesson_id], params[:question][:title], comment, tag)
    if @question
      redirect_to lesson_question_path(@lesson, @question)
    else
      # TODO not yet tested because of post_question
      render :new
    end
  end

end
