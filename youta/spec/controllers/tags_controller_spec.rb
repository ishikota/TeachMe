require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

RSpec.describe TagsController, type: :request do

  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:tag) { lesson.tags.create(FactoryGirl.attributes_for(:tashizan)) }
  let!(:teacher) { FactoryGirl.create(:taro) }
  let!(:someone) { FactoryGirl.create(:kota) }

  describe "#index" do
    context "by not editor of this lesson" do
      before { log_in(someone) }
      it "should redirected" do
        get lesson_tags_path(lesson)
        expect(page).to redirect_to root_path
      end
    end
    context "by editor of this lesson" do
      before { log_in(teacher) }
      it "should assign @lesson and @tags" do
        get lesson_tags_path(lesson)
        expect(assigns(:lesson)).to eq lesson
        expect(assigns(:tags)).to eq lesson.tags
      end
    end
  end

  describe "#create" do
    let(:params) { { tags: "kakezan,warizan" } }
    context "by not editor of this lesson" do
      before { log_in(someone) }
      it "should not create new tag" do
        expect { 
          post lesson_tags_path(lesson), params
        }.not_to change { lesson.tags.size }
      end
    end
    context "by not editor of this lesson" do
      before { log_in(teacher) }
      it "should create new tag" do
        expect { 
          post lesson_tags_path(lesson), params
        }.to change { lesson.tags.size }.by(2)
      end
    end
  end

  describe "#destroy" do
    context "by not editor of this lesson" do
      before { log_in(someone) }
      it "should not delete the tag" do
        expect {
          delete lesson_tag_path(lesson, tag)
        }.not_to change { lesson.tags.size }
      end
    end
    context "by not editor of this lesson" do
      before { log_in(teacher) }
      it "should delete the tag" do
        expect {
          delete lesson_tag_path(lesson, tag)
        }.to change { lesson.tags.size }.by(-1)
      end
    end
  end

end
