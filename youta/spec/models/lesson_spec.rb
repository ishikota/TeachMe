require 'spec_helper'

describe Lesson do
  let(:lesson) { Lesson.new(title: "sansu", day_of_week: 0, period: 1) }
  describe "validation" do
    describe "when title is empty" do
      before { lesson.title = "" }
      it { expect(lesson).not_to be_valid }
    end
    describe "day of week range" do
      it { expect { lesson.day_of_week = -1 }.to change { lesson.valid? } }
      it { expect { lesson.day_of_week = 7 }.to change { lesson.valid? } }
      it { expect { lesson.day_of_week = 6 }.not_to change { lesson.valid? } }
    end
    describe "period range" do
      it { expect { lesson.period = 0 }.to change { lesson.valid? } }
      it { expect { lesson.period = 7 }.not_to change { lesson.valid? } }
    end
  end
  
  describe "dependencies" do
    let(:user) { User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_digest: 'foobar') }
    let(:question) { user.questions.create(title:"HelpMe!!", lesson_id: lesson.id) }
    before { lesson.save }
    describe "lesson has many questions" do
      it { expect(lesson.questions).to include(question) }
    end
    describe "lesson has a tag" do
      it { expect { lesson.tags.create(name: "tag") }.to change { Tag.count }.by(1) }
    end
  end

end
