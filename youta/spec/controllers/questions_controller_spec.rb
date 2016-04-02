require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

RSpec.describe QuestionsController, :type => :request do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:tag) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
  let!(:question1) { user.questions.create(title:"Build error", lesson_id: lesson.id) }
  before { log_in(user) }

  describe "#index" do
    let!(:question2) { user.questions.create(title:"NPE", lesson_id: lesson.id) }

    context "without tag filter" do
      it "should assigns lesson to @lesson" do
        get lesson_questions_path(lesson)
        expect(assigns(:lesson)).to eq lesson
        expect(assigns(:questions)).to eq lesson.questions
      end
    end

    context "with tag filter" do
      let!(:tag2) { lesson.tags.create(FactoryGirl.attributes_for(:hikizan)) }
      before { TagRelationship.create(tag_id: tag2.id, question_id: question2.id) }
      it "should assign only filtered questions" do
        get lesson_questions_path(lesson, tag: tag2.name)
        expect(assigns(:questions)).not_to include question1
        expect(assigns(:questions)).to include question2
      end
    end
  end

  describe "#new" do
    it "should assign new question which belongs to lesson" do
      get new_lesson_question_path(lesson)
      expect(assigns(:lesson)).to eq lesson
      expect(assigns(:question).lesson).to eq lesson
    end
  end

  describe "#create" do
    let(:params) {
      { question: { title: lesson.title, tags: tag.id }, comment: { content: "Help me" } }
    }
    before { log_in(user) }
    it "should creates new question and render the questions page" do
      post lesson_questions_path(lesson), params
      question = Question.find_by_title(lesson.title)
      expect(question.tags).to include tag
      expect(question.user).to eq user
      expect(response).to redirect_to lesson_question_path(lesson.id, question.id)
    end
    context "when content is empty" do
      before { params[:comment][:content] = nil }
      it "should not create new question" do
        expect {
          post lesson_questions_path(lesson), params
        }.not_to change { Question.count }
      end
    end
  end

  describe "#show" do
    before { log_in(user) }
    it "should display question about Build error" do
      get lesson_question_path(lesson, question1)
      expect(assigns(:lesson)).to eq lesson
      expect(assigns(:question)).to eq question1
    end
  end

end
