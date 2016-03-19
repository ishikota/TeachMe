require 'spec_helper'

describe Subscription do
  let(:relation) { Subscription.new(user_id: 0, lesson_id: 0) }
  describe "validation" do
    describe "when user_id is not present" do
      before { relation.user_id = nil }
      it { expect(relation).not_to be_valid }
    end
    describe "when lesson_id is not present" do
      before { relation.lesson_id = nil }
      it { expect(relation).not_to be_valid }
    end
  end


  describe "dependencies" do
    let!(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true) }
    let!(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    let!(:relation) { Subscription.create(user_id: user.id, lesson_id: lesson.id) }

    describe "that belongs to user" do
      it { expect(relation.user).to eq user }
    end

    describe "that belongs to lesson" do
      it { expect(relation.lesson).to eq lesson }
    end

    describe "that connect user and lesson" do
      it { expect(user.lessons).to include(lesson) }
      it { expect(lesson.students).to include(user) }
    end

    describe "that subscription is destroyed when user is destroyed" do
      it { expect { user.destroy }.to change { Subscription.count }.by(-1) }
    end

    describe "that subscription is destroyed when lesson is destroyed" do
      it { expect { lesson.destroy }.to change { Subscription.count }.by(-1) }
    end
  end
end
