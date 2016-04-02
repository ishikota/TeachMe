require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

describe LessonsController, type: :request do

  describe "GET 'index'" do
    before {
      log_in(FactoryGirl.create(:taro))
      FactoryGirl.create(:sansu)
      FactoryGirl.create(:kokugo)
    }
    it "should assigns all lessons to @lessons" do
      get lessons_path
      expect(assigns(:lessons)).to eq Lesson.all
    end
  end

  describe "GET 'new'" do
    before { log_in(FactoryGirl.create(:admin)) }
    it "should assigns empty lesson object to @lesson" do
      get '/lessons/new'
      expect(assigns(:lesson)).to be_a(Lesson)
    end
  end

  describe "#create" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:params) { { lesson: { day_of_week: 0, period: 1, title: title } } }
    before { log_in(admin) }

    describe "when params is correct" do
      let(:title) { "sansu" }
      it "should create new lesson" do
        post lessons_path, params
        lesson = Lesson.find_by_title(title)
        expect(lesson.editors).to include(admin)
      end
    end

    describe "when params is invalid" do
      let(:title) { "" }
      it "should not create new lesson" do
        expect { post lessons_path, params }.not_to change { Lesson.count }
      end
    end
  end

  describe "#edit" do
    before { log_in(FactoryGirl.create(:admin)) }
    let(:lesson) { FactoryGirl.create(:lesson) }
    it "should assign sansu to @lesson" do
      get edit_lesson_path(lesson)
      expect(assigns(:lesson)).to eq lesson
    end
  end

  describe "#update" do
    let!(:lesson) { FactoryGirl.create(:sansu) }
    let!(:tashizan) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
    let!(:hikizan) { lesson.tags.create(FactoryGirl.attributes_for(:hikizan)) }
    let!(:kakezan) { lesson.tags.create(FactoryGirl.attributes_for(:kakezan)) }

    describe "lesson title" do
      let(:params) { { lesson: { title: "sugaku"} } }
      context "admin user" do
        before { log_in(FactoryGirl.create(:admin)) }
        it "should update title from sansu to sugaku" do
          put lesson_path(lesson), params
          lesson.reload
          expect(lesson.title).to eq 'sugaku'
          expect(response).to render_template(:edit)
        end
      end
      context "not admin user" do
        before { log_in(FactoryGirl.create(:user)) }
        it "should not update" do
          expected = lesson.title
          put lesson_path(lesson), params
          lesson.reload
          expect(lesson.title).to eq expected
        end
      end
    end
    describe "with invalid params" do
      before { log_in(FactoryGirl.create(:admin)) }
      let(:params) { { lesson: { day_of_week: -1, title: "" } } }
      it "should render edit page again" do
        put lesson_path(lesson), params
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destroy" do
    before { log_in(FactoryGirl.create(:admin)) }
    let!(:lesson) { FactoryGirl.create(:lesson) }
    it "should success" do
      delete lesson_path(lesson)
      expect(Lesson.exists?(lesson.id)).to be_falsey
      expect(response).to redirect_to lessons_path
    end
  end

end
