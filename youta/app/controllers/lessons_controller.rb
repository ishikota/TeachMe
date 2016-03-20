class LessonsController < ApplicationController
  def index
    @lessons = Lesson.all
  end
  def new
    @lesson = Lesson.new
  end
end
