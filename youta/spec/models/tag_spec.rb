require 'rails_helper'

describe Tag do
  let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
  let(:tag) { Tag.new(name: "tag", lesson_id: lesson.id) }

  describe "validation" do
    describe "when name is empty" do
      before { tag.name = "" }
      it { expect(tag).not_to be_valid }
    end
    describe "when lesson_id is not present" do
      before { tag.lesson_id = nil }
      it { expect(tag).not_to be_valid }
    end
  end

  describe "dependencies" do
    describe "belongs to lesson" do
      it { expect(tag.lesson).to eq lesson }
    end
  end

end
