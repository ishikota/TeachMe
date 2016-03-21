class QuestionsController < ApplicationController
  def index
    @lesson = Lesson.find(params[:lesson_id])
    @questions = Question.all
  end
end
