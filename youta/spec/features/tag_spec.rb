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

  before { log_in(teacher) }

  describe "#index" do
    it "should display tags attached to the lesson"
  end

  describe "#create" do
    it "should append new tag on the tag list"
  end

  describe "#destroy" do
    it "should delete the tag from tag list"
  end

end
