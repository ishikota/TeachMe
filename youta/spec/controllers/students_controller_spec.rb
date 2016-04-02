require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

RSpec.describe StudentsController, :type => :request do

  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:editor) { FactoryGirl.create(:taro) }
  let!(:student) { FactoryGirl.create(:ishimoto) }

  before { EditorRelationship.create(user_id: editor.id, lesson_id: lesson.id) }

  describe "#index" do

    context "by not editor of this lesson" do
      before { log_in(student) }
      it "should be redirected" do
        get lesson_students_path(lesson)
        expect(response).to redirect_to root_path
      end
    end

    context "by editor of this lesson" do
      before { log_in(editor) }
      it "should display student who subscribes the lesson" do
        get lesson_students_path(lesson)
        expect(assigns(:lesson)).to eq lesson
        expect(assigns(:students)).to eq lesson.students
      end
    end

  end

  describe "#create" do

    let(:file_name) { "spec/fixtures/lecture_students.csv" }
    let(:file_path) { fixture_file_upload(file_name, 'text/csv') }
    let(:params) { { students_csv: file_path } }

    context "by not editor of this lesson" do
      before { log_in(student) }
      it "should not create new subscription" do
        post lesson_students_path(lesson), params
        expect(lesson.students.size).to eq 0
      end
    end

    context "by editor of this lesson" do
      before { log_in(editor) }
      it "should add 3 new students from csv file" do
        post lesson_students_path(lesson), params
        expect(lesson.students.size).to eq 3
      end
    end
  end

  describe "#destroy" do

    before {
      student.subscriptions.create(lesson_id: lesson.id)
    }

    context "by not editor of this lesson" do
      before { log_in(student) }
      it "should fail to delete subscription" do
        delete lesson_student_path(lesson, student)
        expect(student.lessons).to include lesson
      end
    end

    context "by editor of this lesson" do
      before {
        log_in(editor)
      }
      it "should unsubscribe student but not delete him" do
        delete lesson_student_path(lesson, student)
        expect(student.lessons).not_to include lesson
      end
    end
  end

end
