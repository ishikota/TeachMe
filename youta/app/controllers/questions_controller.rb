class QuestionsController < ApplicationController
  def index
    @lesson = Lesson.find(params[:lesson_id])
    @questions = Question.all
  end

  def new
    @lesson = Lesson.find(params[:lesson_id])
    @question = @lesson.questions.build
  end

end
