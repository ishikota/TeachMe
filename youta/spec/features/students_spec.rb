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

  describe "add new user through csv file" do
    it "should append new users on the students list" do
      attach_students_file
      click_button '追加'
      expect(page).to have_selector 'li.user-row', count: 4
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
