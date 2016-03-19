require 'spec_helper'

describe GoodRelationship do
  let(:relation) { GoodRelationship.new(user_id: 0, question_id: 0) }
  describe "validation" do
    describe "when foreign_key is not present" do
      context "user_id" do
        before { relation.user_id = nil }
        it { expect(relation).not_to be_valid }
      end
      context "question_id" do
        before { relation.question_id = nil }
        it { expect(relation).not_to be_valid }
      end
    end
  end
  describe "dependencies" do
    let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true) }
    let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    let(:question) { user.questions.create(title:"HelpMe!!", lesson_id: lesson.id) }
    let!(:relation) { GoodRelationship.create(user_id: user.id, question_id: question.id) }

    describe "that question has many user through GoodRelationship" do
      it { expect(question.good_people).to include(user) }
    end

    describe "that user has many questions through GoodRelationship" do
      it { expect(user.good_questions).to include(question) }
    end

    describe "that good relationship is left even if user is destroyed" do
      it { expect { user.destroy }.not_to change { GoodRelationship.count } }
    end

    describe "that good relationship is destroyed when question is destroyed" do
      it { expect { question.destroy }.to change { GoodRelationship.count }.by(-1) }
    end
  end

end
