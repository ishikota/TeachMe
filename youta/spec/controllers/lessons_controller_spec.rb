require 'spec_helper'

describe LessonsController do

  describe "GET 'index'" do
    before {
      Lesson.create(title: "sansu", day_of_week: 0, period: 1)
      Lesson.create(title: "kokugo", day_of_week: 1, period: 2)
    }
    it "should assigns all lessons to @lessons" do
      get 'index'
      expect(assigns(:lessons)).to eq Lesson.all
    end
  end

end
