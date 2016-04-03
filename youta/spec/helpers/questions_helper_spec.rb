require 'rails_helper'

RSpec.describe QuestionsHelper, type: :helper do

  describe "tag manager" do

    let!(:lesson) { FactoryGirl.create(:lesson) }
    let(:tags) { [tag1, tag2, tag3] }
    let(:tag1) { lesson.tags.create(name: "tag1") }
    let(:tag2) { lesson.tags.create(name: "tag2") }
    let(:tag3) { lesson.tags.create(name: "tag3") }
    let(:all_tag) { "all" }

    context "when current tag is empty (means no filter)" do
      it "should return all-tag as current_tag and rest tag as rest_tags" do
        current_tag = nil
        current_tag, rest_tag = helper.manage_tags(tags, current_tag, all_tag)
        expect(current_tag).to eq all_tag
        expect(rest_tag).to eq %w"tag1 tag2 tag3"
      end
    end
    context "when current tag is a usual tag" do
      it "should return tag2 as current_tag and all-tag and rest tags as rest-tags" do
        current_tag = "tag2"
        current_tag, rest_tag = helper.manage_tags(tags, current_tag, all_tag)
        expect(current_tag).to eq "tag2"
        expect(rest_tag).to eq %w"all tag1 tag3"
      end
    end
  end
end
