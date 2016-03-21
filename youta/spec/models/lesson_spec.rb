require 'rails_helper'

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

  describe "string converter" do
    it "should convert day_of_week flg to string" do
      expect(Lesson.day_of_week_to_str(0)).to eq '月曜'
      expect(Lesson.day_of_week_to_str(4)).to eq '金曜'
      expect(Lesson.day_of_week_to_str(5)).to eq nil
    end
    it "should convert period flg to string" do
      expect(Lesson.period_to_str(0)).to eq nil
      expect(Lesson.period_to_str(1)).to eq '1限'
    end
    describe "convert attached tags to comma separated string" do
      let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }

      context "when no tag is attached" do
        it { expect(lesson.tags_to_str).to be_empty }
      end
      context "when two tag is attached" do
        before {
          lesson.tags.create(name: "tashizan")
          lesson.tags.create(name: "hikizan")
        }
        it { expect(lesson.tags_to_str).to eq 'tashizan,hikizan' }
      end
    end
  end

end
