require 'rails_helper'

RSpec.describe QuestionsController, :type => :request do
  let!(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar') }
  let!(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
  let!(:tag) { lesson.tags.create(name: "tashizan") }

  describe "GET index" do
    let!(:question1) { user.questions.create(title:"Build error", lesson_id: lesson.id) }
    let!(:question2) { user.questions.create(title:"NPE", lesson_id: lesson.id) }

    it "assigns all questions to @questions" do
      get lesson_questions_path(lesson)
      expect(assigns(:lesson)).to eq lesson
      expect(assigns(:questions)).to eq Question.all
    end
  end

  describe "GET new" do
    it "assigns new question which belongs to lesson" do
      get new_lesson_question_path(lesson)
      expect(assigns(:lesson)).to eq lesson
      expect(assigns(:question).lesson).to eq lesson
    end
  end

  describe "#create" do
    let(:params) {
      { question: { title: lesson.title, tags: tag.id }, comment: { content: "Help me" } }
    }
    let(:login_params) {
      { session: { student_id: "A1178086", password: 'foobar' } }
    }
    before { post login_path, login_params }
    it "should creates new question and render the questions page" do
      post lesson_questions_path(lesson), params
      question = Question.find_by_title(lesson.title)
      expect(question.tags).to include tag
      expect(question.user).to eq user
      expect(response).to redirect_to lesson_question_path(lesson.id, question.id)
    end
  end

end
