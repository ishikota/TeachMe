require 'rails_helper'

describe LessonsController, type: :request do

  describe "GET 'index'" do
    before {
      Lesson.create(title: "sansu", day_of_week: 0, period: 1)
      Lesson.create(title: "kokugo", day_of_week: 1, period: 2)
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
    before {
      user = User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar')
      params = { session: { student_id: "A1178086", password: "foobar" } }
      post login_path, params
    }

    describe "when params is correct" do
      let(:params) { { lesson: { day_of_week: 0, period: 1, title: "sansu", tags: "tag1,tag2", students_csv: file_path } } }
      it "should create new lesson and attache passed tags and students and go index page" do
        post lessons_path, params
        expect(Lesson.count).to eq 1
        expect(Tag.count).to eq 2
        expect(User.count).to eq 3
        expect(response).to redirect_to lessons_path
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

  describe "#edit" do
    let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    it "should assign sansu to @lesson" do
      get edit_lesson_path(lesson)
      expect(assigns(:lesson)).to eq lesson
    end
  end

  describe "#update" do
    let!(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    let!(:tashizan) { lesson.tags.create(name:"tashizan") }
    let!(:hikizan) { lesson.tags.create(name:"hikizan") }

    describe "when update param is valid" do
      let(:params) { { lesson: { title: "sugaku", tags: "tashizan, kakezan" } } }
      it "should update sansu to sugaku" do
        put lesson_path(lesson), params
        lesson.reload
        expect(lesson.title).to eq 'sugaku'
        expect(lesson.tags.size).to eq 2
        expect(lesson.tags).to include(tashizan)
        expect(lesson.tags).not_to include(hikizan)
        expect(response).to render_template(:edit)
      end
    end
    describe "when update params is invalid" do
      let(:params) { { lesson: { day_of_week: -1, title: "" } } }
      it "should render edit page again" do
        put lesson_path(lesson), params
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destroy" do
    let!(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    it "should delete sansu lesson" do
      delete lesson_path(lesson)
      expect(Lesson.exists?(lesson.id)).to be_falsey
      expect(response).to redirect_to lessons_path
    end
  end

end
