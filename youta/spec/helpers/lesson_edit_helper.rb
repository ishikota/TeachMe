require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ImportHelper. For example:
#
# describe ImportHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe LessonEditHelper, type: :helper do
  
  describe "Read student data from csv" do
    describe "should convert csv file to student_ids array" do
      let(:file_name) { "lecture_students.csv" }
      let(:file_path) { fixture_file_upload(file_name, 'text/csv') }
      let(:result) { %w"A1178086 A1178087 A1178088" }
      it { expect(helper.send(:read_student_from_csv, file_path)).to eq result }
    end

    let(:student_ids) { %w"A1178086 A1178087 A1178088" }
    let(:password) { "foobar" }
    it "should convert student_ids to User object array" do
      students = helper.send(:import_students, student_ids, password)
      expect(User.count).to eq student_ids.size
      expect(students.first.authenticate(password)).to be_truthy
      students.each_with_index { |student, idx|
        expect(student.student_id).to eq student_ids[idx].downcase
      }
    end

    describe "convert csv data to User object array" do
      let(:file_name) { "lecture_students.csv" }
      let(:file_path) { fixture_file_upload(file_name, 'text/csv') }
      let(:password) { 'foobar' }
      let(:result) { %w"A1178086 A1178087 A1178088" }
      let(:students) { helper.read_csv_student_id(file_path, password) }
      specify "students have expected student_ids" do
        students.each_with_index { |student, idx|
          expect(student.student_id).to eq result[idx].downcase
        }
      end
    end
  end

  describe "Update tag data" do
    let(:tag1) { "tashizan" }
    let(:tag2) { "hikizan" }
    let(:tag3) { "kakezan" }
    let(:lesson) { Lesson.create(title: "sansu", day_of_week: 0, period: 1) }
    before {
      Tag.create(name: tag1, lesson_id: lesson.id)
      Tag.create(name: tag2, lesson_id: lesson.id)
    }

    describe "add new tag data" do
      let(:src) { "#{tag1}, #{tag2}, #{tag3}" }
      let!(:tags) { helper.read_csv_tags_for_lesson(lesson.id, src) }
      it "should create only hikizan tag" do
        expect(Tag.count).to eq (3)
        expect(tags).to include(Tag.find_by(name: tag3))
      end
    end

    describe "delete tag" do
      let(:src) { "#{tag1}, #{tag3}" }
      let!(:tags) { helper.read_csv_tags_for_lesson(lesson.id, src) }
      it "should create kakezan tag and delete hikizan tag" do
        expect(Tag.count).to eq 2
        expect(tags).not_to include(Tag.find_by_name(tag2))
        expect(tags).to include(Tag.find_by_name(tag3))
      end
    end

  end

end
