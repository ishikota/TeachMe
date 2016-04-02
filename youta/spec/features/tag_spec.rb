require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Tags", type: :feature do

  let!(:teacher) { FactoryGirl.create(:user) }
  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:tag_tashizan) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
  let!(:tag_hikizan) { lesson.tags.create(FactoryGirl.attributes_for(:hikizan)) }

  before {
    EditorRelationship.create(user_id: teacher.id, lesson_id: lesson.id)
    log_in(teacher)
    visit lesson_tags_path(lesson)
  }

  describe "#index" do
    it "should display tags attached to the lesson" do
      expect(page).to have_content tag_tashizan.name
    end
  end

  describe "#create" do
    it "should append new tag on the tag list"
  end

  describe "#destroy" do
    it "should delete the tag from tag list"
  end

end
