require 'rails_helper'

describe LessonsController, type: :request do

  describe "GET 'index'" do
    before {
      Lesson.create(title: "sansu", day_of_week: 0, period: 1)
      Lesson.create(title: "kokugo", day_of_week: 1, period: 2)
    }
    it "should assigns all lessons to @lessons" do
      get '/lessons/index'
      expect(assigns(:lessons)).to eq Lesson.all
    end
  end

  describe "GET 'new'" do
    it "should assigns empty lesson object to @lesson" do
      get '/lessons/new'
      expect(assigns(:lesson)).to be_a(Lesson)
    end
  end


end
