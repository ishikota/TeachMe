require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Students", :type => :feature do

  def attach_students_file
    attach_file '受講者', "#{Rails.root}/spec/fixtures/lecture_students.csv"
  end

  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:editor) { FactoryGirl.create(:kota) }
  let!(:student) { FactoryGirl.create(:taro) }

  before {
    EditorRelationship.create(user_id: editor.id, lesson_id: lesson.id)
    Subscription.create(user_id: student.id, lesson_id: lesson.id)
    log_in(editor)
    visit lesson_students_path(lesson)
  }

  describe "index page" do
    it "should display students who subscribes the lesson" do
      expect(page).to have_content student.name
    end
  end

  describe "click append button" do
    context "with attaching students id csv file" do
      it "should append new users on the students list" do
        attach_students_file
        expect { click_button '追加' }.to change { lesson.students.size }.by(3)
        expect(page).to have_selector 'li.user-row', count: 4
      end
    end

    context "without students id csv file" do
      it "should fail to append student and display message" do
        expect { click_button '追加' }.not_to change { lesson.students.size }
        expect(page).to have_selector '.alert-warning'
      end
    end

    describe "flash message" do
      before {
        Subscription.create(user_id: editor.id, lesson_id: lesson.id)
      }

      it "should take care about already registered students" do
        attach_students_file
        click_button '追加'
        expect(page).not_to have_content '3人'
        expect(page).to have_content '2人'
      end
    end

  end

  describe "delete subscription" do
    it "should remove deleted user from students list" do
      within "#row-student-#{student.id}" do
        click_on '削除'
      end
      expect(page).not_to have_content student.name
    end
  end

end
