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

  describe "#create" do
    let(:file_name) { "spec/fixtures/lecture_students.csv" }
    let(:file_path) { fixture_file_upload(file_name, 'text/csv') }
    describe "when params is correct" do
      let(:params) { { lesson: { day_of_week: 0, period: 1, title: "sansu", tags: "tag1,tag2", students: file_path } } }
      it "should create new lesson and attache passed tags and students and go index page" do
        post lessons_path, params
        expect(Lesson.count).to eq 1
        expect(Tag.count).to eq 2
        expect(User.count).to eq 3
        expect(response).to render_template(:index)
      end
    end
    context "when params is not enough" do
      let(:params) { { lesson: { day_of_week: 0, period: 1, title: "", tags: "tag1,tag2" } } }
      it "should redirect to lesson#new" do
        post lessons_path, params
        expect(response).to render_template(:new)
      end
    end
  end


end
