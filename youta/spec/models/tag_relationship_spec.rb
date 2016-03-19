require 'spec_helper'

describe TagRelationship do
  let(:relation) { TagRelationship.new(tag_id: 0, question_id: 0) }
  describe "validation" do
    describe "when foreign_key is not present" do
      context "tag_id" do
        before { relation.tag_id = nil }
        it { expect(relation).not_to be_valid }
      end
      context "question_id" do
        before { relation.question_id = nil }
        it { expect(relation).not_to be_valid }
      end
    end
  end
  describe "dependencies" do
    let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar') }
    let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    let(:question) { user.questions.create(title:"HelpMe!!", lesson_id: lesson.id) }
    let(:tag) { Tag.create(name: "tag", lesson_id: lesson.id) }
    let!(:relation) { TagRelationship.create(tag_id: tag.id, question_id: question.id) }

    describe "that belongs to tag" do
      it { expect(question.tags).to include(tag) }
    end

    describe "that belongs to question" do
      it { expect(tag.questions).to include(question) }
    end

    describe "that tag relationship is destroyed when tag is destroyed" do
      it { expect { tag.destroy }.to change { TagRelationship.count }.by(-1) }
    end

    describe "that tag relationship is destroyed when question is destroyed" do
      it { expect { question.destroy }.to change { TagRelationship.count }.by(-1) }
    end
  end

end
