require 'rails_helper'

RSpec.describe QuestionsController, :type => :request do

  describe "GET index" do
    let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_digest: 'foobar') }
    let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    let!(:question1) { user.questions.create(title:"Build error", lesson_id: lesson.id) }
    let!(:question2) { user.questions.create(title:"NPE", lesson_id: lesson.id) }

    it "assigns all questions to @questions" do
      get lesson_questions_path(lesson)
      expect(assigns(:lesson)).to eq lesson
      expect(assigns(:questions)).to eq Question.all
    end
  end

end
