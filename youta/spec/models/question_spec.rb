require 'spec_helper'

describe Question do
  let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true) }
  let(:question) { user.questions.build(title:"HelpMe!!") }

  describe "default value" do
    it { expect(question.user_id).to eq user.id }
    it { expect(question.solved).to be_false }
  end

  describe "validation" do
    describe "when title is empty" do
      before { question.title = "" }
      it { expect(question).not_to be_valid }
    end
  end

  describe "dependencies" do
    before {
      user.save
      question.save
    }
    describe "when user_id is not present" do
      before { question.user_id = nil }
      it { expect(question).not_to be_valid }
    end
    describe "that Comment depends on question" do
      let!(:comment) { user.comment(question, "TeachMe!!") }
      it { expect(comment.user_id).to eq user.id }
      it { expect(comment.question_id).to eq question.id }
      it { expect(comment.content).to eq "TeachMe!!" }
      it { expect { question.destroy }.to change { Comment.count }.by(-1) }
    end
  end
end
