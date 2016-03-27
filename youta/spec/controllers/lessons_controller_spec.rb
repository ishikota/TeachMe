require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

describe LessonsController, type: :request do

  describe "GET 'index'" do
    before {
      FactoryGirl.create(:sansu)
      FactoryGirl.create(:kokugo)
    }
    it "should assigns all lessons to @lessons" do
      get lessons_path
      expect(assigns(:lessons)).to eq Lesson.all
    end
  end

  describe "GET 'new'" do
    it "should assigns empty lesson object to @lesson" do
      get '/lessons/new'
      expect(assigns(:lesson)).to be_a(Lesson)
    end
  end

  describe "#create" do
    let(:file_name) { "spec/fixtures/lecture_students.csv" }
    let(:file_path) { fixture_file_upload(file_name, 'text/csv') }
    let(:params) { { lesson: { day_of_week: 0, period: 1, title: "sansu", tags: "tag1,tag2", students_csv: file_path } } }
    before {
      taro = FactoryGirl.create(:taro)
      log_in(taro)
    }

    describe "when params is correct" do
      it "should attach tag on new lesson and go lesson page" do
          post lessons_path, params
          lesson = Lesson.find_by_title("sansu")
          expect(lesson.tags.count).to eq 2
          expect(response).to redirect_to lessons_path
      end

      context "all students are not registered yet" do
        specify "creates new students and make subscription" do
          expect { post lessons_path, params }.to change { User.count }.from(1).to(4)
          lesson = Lesson.find_by_title("sansu")
          expect(lesson.students.size).to eq 3
        end
      end
      context "one of students already registered to this app" do
        let!(:already_registed_user) { FactoryGirl.create(:user) }
        specify "creates only not registered student. But make subscription on all students" do
          expect { post lessons_path, params }.to change { User.count }.from(2).to(4)
          lesson = Lesson.find_by_title("sansu")
          expect(lesson.students.size).to eq 3
        end
      end
    end

    describe "when params is not enough" do
      context "lesson parameter is invalid" do
        before { params[:lesson][:title] = "" }
        it "should redirect to lesson#new" do
          expect { post lessons_path, params }.not_to change { Lesson.count }
          expect(response).to render_template(:new)
        end
      end
      context "no students is specified" do
        before { params[:lesson][:students_csv] = nil }
        it "should not create new lesson" do
          expect { post lessons_path, params }.not_to change { Lesson.count }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "#edit" do
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
      let(:params) { { lesson: { title: "sugaku", tags: [tashizan.name, kakezan.name].join(',') } } }
      it "should update title from sansu to sugaku" do
        put lesson_path(lesson), params
        lesson.reload
        expect(lesson.title).to eq 'sugaku'
        expect(lesson.tags.size).to eq 2
        expect(lesson.tags).to include(tashizan)
        expect(lesson.tags).not_to include(hikizan)
        expect(response).to render_template(:edit)
      end
    end
    describe "with invalid params" do
      let(:params) { { lesson: { day_of_week: -1, title: "" } } }
      it "should render edit page again" do
        put lesson_path(lesson), params
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destroy" do
    let!(:lesson) { FactoryGirl.create(:lesson) }
    it "should success" do
      delete lesson_path(lesson)
      expect(Lesson.exists?(lesson.id)).to be_falsey
      expect(response).to redirect_to lessons_path
    end
  end

end
