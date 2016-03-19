require 'spec_helper'

describe User do

  describe "validation" do
    let(:user) { User.new(params) }
    let(:params) { {name: name, student_id: sid, admin: admin } }

    describe "when name" do
      let(:sid) { "A1178086" }
      let(:admin) { true }
      context 'is present' do
        let(:name) { "Kota Ishimoto" }
        it { expect(user).to be_valid }
      end
      context 'is empty' do
        let(:name) { "" }
        it { expect(user).not_to be_valid }
      end
    end

    describe "when student_id" do
      let(:name) { "Kota Ishimoto" }
      let(:admin) { true }
      context 'is valid' do
        let(:sid) { "A1178086" }
        it { expect(user).to be_valid }
      end
      context 'does not start with A or B' do
        let(:sid) { "C1178086" }
        it { expect(user).not_to be_valid }
      end
      context 'is not 8 character' do
        let(:sid) { "A117808" }
        it { expect(user).not_to be_valid }
      end
      context 'has two alphabet' do
        let(:sid) { "AB178086" }
        it { expect(user).not_to be_valid }
      end
      context 'is already used' do
        let(:sid) { "A1178086" }
        before { User.create(name: name, student_id: sid) }
        it { expect(user).not_to be_valid }
      end
    end
  end

  describe "default value" do
    let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086") }
    specify "admin is false when not supplied" do
      expect(user.admin).to be_false
    end
  end

  describe "before save should downcase student_id" do
    let(:sid) { "A1178086" }
    before { User.create(name: "Kota Ishimoto", student_id: sid) }
    it { expect(User.where(student_id: sid.downcase)).to be_present }
  end

  describe "that comment lefts even if owner is destroyed" do
    let!(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086") }
    let!(:comment) { user.comments.create(content: "Teach Me !!")}
    it { expect { user.destroy }.not_to change {Comment.count} }
  end

  describe "that question is left even if its owner is destroyed" do
    let!(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086") }
    let!(:question) { user.questions.create(title: "Teach Me !!")}
    it { expect { user.destroy }.not_to change {Question.count} }
  end

  describe "#comment" do
    let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086") }
    let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    context "on valid question" do
      let(:question) { user.questions.create(title: "Teach Me !!", lesson_id: lesson.id)}
      it { expect { user.comment(question, "First Comment!!") }.to change { Comment.where(user_id: user.id).count }.by(1) }
    end
    context "on invalid question" do
      let(:question) { user.questions.new }
      it { expect { user.comment(question, "First Comment!!") }.not_to change { Comment.where(user_id: user.id).count } }
    end
  end

end
